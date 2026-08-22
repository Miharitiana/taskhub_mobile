// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:http/http.dart' as http;

// Sur le web, l'attribut "download" d'un <a> n'est honoré par le navigateur
// que pour une URL de même origine — notre API tourne sur un port différent
// de l'app Flutter. On récupère donc les octets nous-mêmes puis on crée une
// URL "blob:" (toujours same-origin), seule façon fiable de forcer un vrai
// téléchargement plutôt qu'une simple navigation vers l'image.
Future<void> downloadFile(String url, String fileName) async {
  final response = await http.get(Uri.parse(url));
  final blob = html.Blob([response.bodyBytes]);
  final blobUrl = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: blobUrl)
    ..download = fileName
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(blobUrl);
}
