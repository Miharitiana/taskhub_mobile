import 'package:flutter/material.dart';

import 'conversation_screen.dart';

const _adaiOrange = Color(0xFFB5651D);

class ConversationPreview {
  final String id;
  final String projectName;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String lastSender;
  final String lastMessage;
  final String time;
  final int unreadCount;

  const ConversationPreview({
    required this.id,
    required this.projectName,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.lastSender,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
  });
}



class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  final List<ConversationPreview> _conversations = const [
    ConversationPreview(
      id: '1',
      projectName: 'Mobile App',
      icon: Icons.phone_iphone,
      iconBg: Color(0xFF3A9B54),
      iconColor: Colors.white,
      lastSender: 'Mirindra R.',
      lastMessage: 'J\'ai mis à jour l\'écran de connexion, à tester s\'il vous plaît.',
      time: '10:32',
      unreadCount: 3,
    ),
    
    ConversationPreview(
      id: '2',
      projectName: 'Backend API',
      icon: Icons.terminal,
      iconBg: Color(0xFF8B5CF6),
      iconColor: Colors.white,
      lastSender: 'Tovo M.',
      lastMessage: 'L\'endpoint d\'authentification est prêt pour les tests.',
      time: '09:15',
      unreadCount: 2,
    ),
    ConversationPreview(
      id: '3',
      projectName: 'Dashboard',
      icon: Icons.dashboard_outlined,
      iconBg: Color(0xFFE0A527),
      iconColor: Colors.white,
      lastSender: 'Aina R.',
      lastMessage: 'Le design du tableau de bord est validé.',
      time: 'Hier',
      unreadCount: 1,
    ),
    ConversationPreview(
      id: '4',
      projectName: 'Bugs & Support',
      icon: Icons.bug_report_outlined,
      iconBg: Color(0xFF2E7CD6),
      iconColor: Colors.white,
      lastSender: 'Rakoto N.',
      lastMessage: 'Bug #125 corrigé dans la dernière version.',
      time: 'Hier',
    ),
    ConversationPreview(
      id: '5',
      projectName: 'Marketing Site',
      icon: Icons.campaign_outlined,
      iconBg: Color(0xFFE0709B),
      iconColor: Colors.white,
      lastSender: 'Rija S.',
      lastMessage: 'Le contenu de la page d\'accueil est en ligne.',
      time: '26/06',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Conversations',
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              'Discussions par projet',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _conversations.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                return _ConversationTile(conversation: _conversations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationPreview conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConversationScreen(projectName: conversation.projectName),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: conversation.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(conversation.icon, color: conversation.iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.projectName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${conversation.lastSender}: ${conversation.lastMessage}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.time,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                if (conversation.unreadCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: _adaiOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
