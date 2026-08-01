import 'package:flutter/material.dart';

const _adaiOrange = Color(0xFFB5651D);

enum NotificationFilter { toutes, nonLues, mentions }

enum NotificationType {
  nouvelleTache,
  depassementTemps,
  tacheATester,
  nouveauCommentaire,
  miseAJour,
  echeanceProche,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final String time;
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    this.isRead = false,
  });
}

class NotificationListeScreen extends StatefulWidget {
  const NotificationListeScreen({super.key});

  @override
  State<NotificationListeScreen> createState() => _NotificationListeScreenState();
}

class _NotificationListeScreenState extends State<NotificationListeScreen> {
  NotificationFilter _filter = NotificationFilter.toutes;

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      type: NotificationType.nouvelleTache,
      title: 'Nouvelle tâche assignée',
      description: 'Tovo M. vous a assigné la tâche "Intégration de l\'écran de connexion".',
      time: '2 min',
    ),
    AppNotification(
      id: '2',
      type: NotificationType.depassementTemps,
      title: 'Dépassement de temps',
      description: 'La tâche "Design écran tableau de bord" dépasse le temps estimé.',
      time: '25 min',
    ),
    AppNotification(
      id: '3',
      type: NotificationType.tacheATester,
      title: 'Tâche à tester',
      description: 'La tâche "API gestion des utilisateurs" est prête pour les tests.',
      time: '1 h',
    ),
    AppNotification(
      id: '4',
      type: NotificationType.nouveauCommentaire,
      title: 'Nouveau commentaire',
      description: 'Aina R. a commenté la tâche "Intégration de la vue UI".',
      time: '2 h',
    ),
    AppNotification(
      id: '5',
      type: NotificationType.miseAJour,
      title: 'Mise à jour de tâche',
      description: 'Rakoto N. a mis à jour le statut de la tâche "Correction bug formulaire".',
      time: '3 h',
    ),
    AppNotification(
      id: '6',
      type: NotificationType.echeanceProche,
      title: 'Échéance proche',
      description: 'La tâche "Tests unitaires" arrive à échéance demain.',
      time: '5 h',
    ),
  ];

  List<AppNotification> get _filteredNotifications {
    switch (_filter) {
      case NotificationFilter.toutes:
        return _notifications;
      case NotificationFilter.nonLues:
        return _notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.mentions:
        return _notifications
            .where((n) => n.type == NotificationType.nouveauCommentaire)
            .toList();
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final notif = _notifications.firstWhere((n) => n.id == id);
      notif.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'Toutes',
                  selected: _filter == NotificationFilter.toutes,
                  onTap: () => setState(() => _filter = NotificationFilter.toutes),
                ),
                _FilterChip(
                  label: 'Non lues',
                  selected: _filter == NotificationFilter.nonLues,
                  onTap: () => setState(() => _filter = NotificationFilter.nonLues),
                ),
                _FilterChip(
                  label: 'Mentions',
                  selected: _filter == NotificationFilter.mentions,
                  onTap: () => setState(() => _filter = NotificationFilter.mentions),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredNotifications.length,
              itemBuilder: (context, index) {
                final notif = _filteredNotifications[index];
                return _NotificationTile(
                  notification: notif,
                  onMarkRead: () => _markAsRead(notif.id),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: TextButton.icon(
                onPressed: _markAllAsRead,
                style: TextButton.styleFrom(foregroundColor: _adaiOrange),
                icon: const Icon(Icons.check, size: 16),
                label: const Text(
                  'Tout marqué comme lu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: _adaiOrange,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: selected ? _adaiOrange : Colors.grey.shade300),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onMarkRead;

  const _NotificationTile({
    required this.notification,
    required this.onMarkRead,
  });

  ({IconData icon, Color bg, Color fg}) get _iconStyle {
    switch (notification.type) {
      case NotificationType.nouvelleTache:
        return (icon: Icons.assignment_outlined, bg: const Color(0xFFE3F0FB), fg: const Color(0xFF2E7CD6));
      case NotificationType.depassementTemps:
        return (icon: Icons.access_time, bg: const Color(0xFFFDF0DE), fg: _adaiOrange);
      case NotificationType.tacheATester:
        return (icon: Icons.check_circle_outline, bg: const Color(0xFFE5F5E9), fg: const Color(0xFF3A9B54));
      case NotificationType.nouveauCommentaire:
        return (icon: Icons.chat_bubble_outline, bg: const Color(0xFFF1E7FB), fg: const Color(0xFF8B5CF6));
      case NotificationType.miseAJour:
        return (icon: Icons.info_outline, bg: const Color(0xFFE3F0FB), fg: const Color(0xFF2E7CD6));
      case NotificationType.echeanceProche:
        return (icon: Icons.flag_outlined, bg: const Color(0xFFFCE4E4), fg: const Color(0xFFE05B33));
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _iconStyle;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: style.bg,
              shape: BoxShape.circle,
            ),
            child: Icon(style.icon, color: style.fg, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
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
                notification.time,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              if (!notification.isRead) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onMarkRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 9, color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Marquer comme lu',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
