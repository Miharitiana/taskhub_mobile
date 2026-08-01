import 'package:flutter/material.dart';

const _adaiOrange = Color(0xFFB5651D);

class ProfilUserScreen extends StatefulWidget {
  const ProfilUserScreen({super.key});

  @override
  State<ProfilUserScreen> createState() => _ProfilUserScreenState();
}

class _ProfilUserScreenState extends State<ProfilUserScreen> {
  bool _pushNotificationsEnabled = true;

  // TODO: remplacer par les vraies données utilisateur (via API/session)
  final String _userName = 'Mirindra Rakotomalala';
  final String _userRole = 'Chef de projet';
  final String _userAvatarUrl = 'https://i.pravatar.cc/200?img=12';
  final String _language = 'Français';

  void _logout() {
    // TODO: brancher la vraie déconnexion (clear session/token + redirection LoginScreen)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mon profil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://dashboard-wally-process-interne.adaiexpertise.fr/logo_sans_fond.png',
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(_userAvatarUrl),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _userRole,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3A9B54),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'En ligne',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF3A9B54),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF0DE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications_none, color: _adaiOrange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifications push',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Recevoir les notifications sur votre appareil',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _pushNotificationsEnabled,
                    activeColor: _adaiOrange,
                    onChanged: (value) => setState(() => _pushNotificationsEnabled = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Mon compte',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _AccountRow(
                    icon: Icons.person_outline,
                    label: 'Informations personnelles',
                    onTap: () {
                      // TODO: naviguer vers l'écran d'informations personnelles
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _AccountRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Sécurité',
                    onTap: () {
                      // TODO: naviguer vers l'écran de sécurité
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _AccountRow(
                    icon: Icons.language_outlined,
                    label: 'Langue',
                    trailingText: _language,
                    onTap: () {
                      // TODO: afficher le sélecteur de langue
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _AccountRow(
                    icon: Icons.info_outline,
                    label: 'À propos',
                    onTap: () {
                      // TODO: naviguer vers l'écran à propos
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red, size: 18),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Vous serez déconnecté et votre session sera révoquée sur tous vos appareils.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback onTap;

  const _AccountRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
