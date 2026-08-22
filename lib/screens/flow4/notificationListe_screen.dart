import 'package:flutter/material.dart';

import '../flow2/taskDetail_screen.dart';
import '../../models/app_notification.dart';
import '../../services/notification_service.dart';

final _notificationService = NotificationService();

const _adaiOrange = Color(0xFFB5651D);

enum NotificationFilter { toutes, nonLues }

class NotificationListeScreen extends StatefulWidget {
  const NotificationListeScreen({super.key});

  @override
  State<NotificationListeScreen> createState() => _NotificationListeScreenState();
}

class _NotificationListeScreenState extends State<NotificationListeScreen> {
  NotificationFilter _filter = NotificationFilter.toutes;

  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await _notificationService.getNotifications(
        unreadOnly: _filter == NotificationFilter.nonLues,
      );
      if (!mounted) return;
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement des notifications';
      });
    }
  }

  void _onFilterChanged(NotificationFilter filter) {
    setState(() => _filter = filter);
    _loadNotifications();
  }

  Future<void> _markAsRead(AppNotification notification) async {
    if (notification.isRead) return;
    // Optimiste : on met à jour tout de suite, on annule si l'appel échoue.
    setState(() => notification.readAt = DateTime.now());
    try {
      await _notificationService.markAsRead(notification.id);
    } catch (e) {
      if (!mounted) return;
      setState(() => notification.readAt = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onNotificationTap(AppNotification notification) {
    // Marquage lu sans attendre : ne doit pas retarder la navigation.
    _markAsRead(notification);
    if (notification.taskId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskDetailScreen(taskId: notification.taskId!),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    final previousState = _notifications.map((n) => n.readAt).toList();
    setState(() {
      for (final n in _notifications) {
        n.readAt ??= DateTime.now();
      }
    });
    try {
      await _notificationService.markAllAsRead();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        for (var i = 0; i < _notifications.length; i++) {
          _notifications[i].readAt = previousState[i];
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  onTap: () => _onFilterChanged(NotificationFilter.toutes),
                ),
                _FilterChip(
                  label: 'Non lues',
                  selected: _filter == NotificationFilter.nonLues,
                  onTap: () => _onFilterChanged(NotificationFilter.nonLues),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _loadNotifications,
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _notifications.isEmpty
                        ? Center(
                            child: Text(
                              'Aucune notification',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              final notif = _notifications[index];
                              return _NotificationTile(
                                notification: notif,
                                onMarkRead: () => _onNotificationTap(notif),
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

({IconData icon, Color bg, Color fg}) _iconStyleForType(String? type) {
  switch (type) {
    case 'task':
      return (icon: Icons.assignment_outlined, bg: const Color(0xFFE3F0FB), fg: const Color(0xFF2E7CD6));
    case 'deadline':
      return (icon: Icons.flag_outlined, bg: const Color(0xFFFCE4E4), fg: const Color(0xFFE05B33));
    case 'task_validation':
      return (icon: Icons.verified_outlined, bg: const Color(0xFFF1E7FB), fg: const Color(0xFF8B5CF6));
    case 'budget_request':
      return (icon: Icons.payments_outlined, bg: const Color(0xFFE5F5E9), fg: const Color(0xFF3A9B54));
    case 'calendar_event':
      return (icon: Icons.event_outlined, bg: const Color(0xFFE3F0FB), fg: const Color(0xFF2E7CD6));
    case 'project':
      return (icon: Icons.folder_outlined, bg: const Color(0xFFFDF0DE), fg: _adaiOrange);
    case 'sprint':
      return (icon: Icons.timeline_outlined, bg: const Color(0xFFFDF0DE), fg: _adaiOrange);
    case 'time_tracking':
      return (icon: Icons.access_time, bg: const Color(0xFFE5F5E9), fg: const Color(0xFF3A9B54));
    default:
      return (icon: Icons.notifications_outlined, bg: Colors.grey.shade200, fg: Colors.grey.shade600);
  }
}

String _formatRelativeTime(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime.toLocal());
  if (diff.inMinutes < 1) return 'à l\'instant';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min';
  if (diff.inHours < 24) return '${diff.inHours} h';
  if (diff.inDays == 1) return 'Hier';
  if (diff.inDays < 7) return '${diff.inDays} j';
  final local = dateTime.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}';
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onMarkRead;

  const _NotificationTile({
    required this.notification,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final style = _iconStyleForType(notification.type);
    return GestureDetector(
      onTap: onMarkRead,
      child: Container(
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
                    notification.title ?? 'Notification',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? '',
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
                  _formatRelativeTime(notification.createdAt),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                if (!notification.isRead) ...[
                  const SizedBox(height: 8),
                  Container(
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
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
