import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment.dart';
import 'client_service.dart';

class CommentService {
  // Récupère le token sauvegardé au login, requis car les routes
  // getComments/AjoutComments utilisent $request->user() côté Laravel.
  Future<String> _requireToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Utilisateur non authentifié');
    return token;
  }

  // Renommé (au pluriel) et retype en Future<List<Comment>> : getComments()
  // côté Laravel renvoie un tableau de commentaires, pas un seul objet.
  Future<List<Comment>> getComments(int taskId) async {
    final token = await _requireToken();

    final response = await http.get(
      // Route Laravel confirmée : Route::prefix('comments')->group(...)
      // avec Route::get('/{taskId}', ...) → /comments/{taskId}.
      Uri.parse("${ClientService.baseUrl}/comments/$taskId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // Correction : header d'authentification manquant.
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Comment.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  // Correction : accepte maintenant le texte du commentaire (body) et,
  // optionnellement, une image (bytes + nom de fichier). Envoie une requête
  // multipart car Laravel valide 'image' comme un fichier (impossible en JSON).
  Future<Comment> commentAjout(
    int taskId, {
    String? body,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    final token = await _requireToken();

    // Même route que getComments : Route::post('/{taskId}', ...) sous le
    // préfixe 'comments' → /comments/{taskId}.
    final uri = Uri.parse("${ClientService.baseUrl}/comments/$taskId");
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        "Accept": "application/json",
        // Pas de Content-Type manuel ici : http.MultipartRequest gère
        // automatiquement le boundary "multipart/form-data".
        "Authorization": "Bearer $token",
      });

    // 'body' et/ou 'image' : au moins l'un des deux est requis côté Laravel
    // (required_without:image / required_without:body).
    if (body != null && body.isNotEmpty) {
      request.fields['body'] = body;
    }
    if (imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFileName ?? 'comment_image.jpg',
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Correction : Laravel renvoie 201 (Created) sur succès, pas 200.
    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Comment.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }
}
