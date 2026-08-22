import 'package:url_launcher/url_launcher.dart';

// Repli hors web (mobile/desktop) : pas d'API de téléchargement direct sans
// packages supplémentaires (permissions stockage, etc.) — on ouvre le
// fichier dans le navigateur/l'app associée, l'utilisateur peut l'enregistrer
// depuis là.
Future<void> downloadFile(String url, String fileName) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
