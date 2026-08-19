import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/conversation.dart';
import '../models/message.dart';
import '../models/project.dart';
import 'client_service.dart';

class ChatService {
  Future<String> _requireToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Utilisateur non authentifié');
    return token;
  }

  // Annuaire des collègues avec qui démarrer une conversation (direct ou
  // groupe), indépendamment de tout projet. Réutilise ProjectMember : même
  // forme exacte {id, name, role}.
  Future<List<ProjectMember>> getUsers() async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/users"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => ProjectMember.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  // Détail d'une conversation existante (nom, is_group, membres) — utile à
  // l'ouverture d'une conversation, contrairement à getConversations (liste)
  // qui ne renvoie pas les membres.
  Future<Conversation> getConversation(int conversationId) async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/conversations/$conversationId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Conversation.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<List<Conversation>> getConversations() async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/conversations"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Conversation.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  // Correction : le backend n'a plus une seule route de création "générique"
  // (type + project_id) — il expose désormais deux routes distinctes :
  // /conversations/direct (retrouve ou crée la conversation 1-à-1 avec cet
  // utilisateur, jamais de doublon) et /conversations/group (toujours un
  // nouveau groupe). Plus aucune notion de projet dans la création.
  Future<Conversation> createDirect(int userId) async {
    final token = await _requireToken();

    final response = await http.post(
      Uri.parse("${ClientService.baseUrl}/conversations/direct"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"user_id": userId}),
    );

    // 201 si la conversation vient d'être créée, 200 si elle existait déjà
    // (le backend déduplique les conversations directes entre deux mêmes
    // personnes).
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Conversation.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<Conversation> createGroup({
    required String name,
    required List<int> memberIds,
  }) async {
    final token = await _requireToken();

    final response = await http.post(
      Uri.parse("${ClientService.baseUrl}/conversations/group"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "member_ids": memberIds,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Conversation.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<List<Message>> getMessages(int conversationId) async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/conversations/$conversationId/messages"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => Message.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  // Correction : accepte maintenant une image (bytes + nom de fichier), en
  // plus du texte. Laravel valide "image" comme un fichier (impossible en
  // JSON), donc on passe en multipart dès qu'une image est fournie — même
  // logique que CommentService.commentAjout.
  Future<Message> sendMessages(
    int conversationId, {
    String? body,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    final token = await _requireToken();

    final uri = Uri.parse("${ClientService.baseUrl}/conversations/$conversationId/messages");
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

    if (body != null && body.isNotEmpty) {
      request.fields['body'] = body;
    }
    if (imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFileName ?? 'chat_image.jpg',
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Message.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  // Liste des messages contenant un fichier (image) dans la conversation.
  // Contrairement à getMessages, la réponse est un tableau JSON brut (pas de
  // pagination Laravel ici : le contrôleur utilise get(), pas paginate()).
  Future<List<Message>> getFiles(int conversationId) async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/conversations/$conversationId/files"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Message.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<void> markAsRead(int conversationId) async {
    final token = await _requireToken();

    final response = await http.post(
      Uri.parse("${ClientService.baseUrl}/conversations/$conversationId/read"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    } 
  }
}
