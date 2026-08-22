import 'package:flutter/material.dart';

import '../flow4/notificationListe_screen.dart';
import 'projetDetail_screen.dart';
import '../../services/notification_service.dart';

final _notificationService = NotificationService();

const _adaiOrange = Color(0xFFB5651D);

class Project {
  final String name;
  final String description;
  final String letter;
  final Color color;
  final double progress;
  final List<String> memberAvatarUrls;
  final int extraMembersCount;

  const Project({
    required this.name,
    required this.description,
    required this.letter,
    required this.color,
    required this.progress,
    required this.memberAvatarUrls,
    this.extraMembersCount = 0,
  });
}

class ProjetListScreen extends StatefulWidget {
  const ProjetListScreen({super.key});

  @override
  State<ProjetListScreen> createState() => _ProjetListScreenState();
}

class _ProjetListScreenState extends State<ProjetListScreen> {
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadNotifications();
  }

  Future<void> _loadUnreadNotifications() async {
    try {
      final count = await _notificationService.getUnreadCount();
      if (!mounted) return;
      setState(() => _unreadNotifications = count);
    } catch (_) {
      // Erreur silencieuse : le badge reste juste absent, pas bloquant.
    }
  }

  // TODO: remplacer par les vraies données (API projets)
  final int _totalProjects = 12;
  final double _avgProgress = 0.68;
  final int _teamMembers = 28;
  final int _totalTasks = 96;

  final List<Project> _projects = const [
    Project(
      name: 'Plateforme ADAI',
      description: 'Développement de la plateforme',
      letter: 'P',
      color: Color(0xFF7C5CE0),
      progress: 0.75,
      memberAvatarUrls: [
        'https://i.pravatar.cc/100?img=12',
        'https://i.pravatar.cc/100?img=32',
        'https://i.pravatar.cc/100?img=51',
      ],
      extraMembersCount: 3,
    ),
    Project(
      name: 'Application Mobile',
      description: 'Application mobile Flutter',
      letter: 'M',
      color: Color(0xFF3A9B54),
      progress: 0.45,
      memberAvatarUrls: [
        'https://i.pravatar.cc/100?img=45',
        'https://i.pravatar.cc/100?img=33',
        'https://i.pravatar.cc/100?img=47',
      ],
      extraMembersCount: 2,
    ),
    Project(
      name: 'Site Web Marketing',
      description: 'Refonte du site marketing',
      letter: 'W',
      color: Color(0xFFE0A527),
      progress: 0.30,
      memberAvatarUrls: [
        'https://i.pravatar.cc/100?img=15',
        'https://i.pravatar.cc/100?img=22',
        'https://i.pravatar.cc/100?img=27',
      ],
      extraMembersCount: 4,
    ),
    Project(
      name: 'API Intégration',
      description: 'Intégration des services tiers',
      letter: 'A',
      color: Color(0xFF2E7CD6),
      progress: 0.90,
      memberAvatarUrls: [
        'https://i.pravatar.cc/100?img=51',
        'https://i.pravatar.cc/100?img=12',
        'https://i.pravatar.cc/100?img=33',
      ],
      extraMembersCount: 1,
    ),
    Project(
      name: 'Recherche & IA',
      description: 'Module IA et rapports',
      letter: 'R',
      color: Color(0xFFE0709B),
      progress: 0.60,
      memberAvatarUrls: [
        'https://i.pravatar.cc/100?img=45',
        'https://i.pravatar.cc/100?img=22',
        'https://i.pravatar.cc/100?img=15',
      ],
      extraMembersCount: 2,
    ),
  ];

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationListeScreen(),
      ),
    );
    // Recharge au retour : l'utilisateur a pu marquer des notifications
    // comme lues (une par une ou "Tout marqué comme lu") pendant l'écran.
    _loadUnreadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          _buildBody(context),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF7C5CE0),
              onPressed: () {
                // TODO: créer un nouveau projet
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.menu, color: Colors.grey.shade800),
                const Text(
                  'Projets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.grey.shade800),
                      onPressed: () {
                        // TODO: afficher la recherche de projets
                      },
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications_none, color: Colors.grey.shade800),
                          onPressed: _openNotifications,
                        ),
                        if (_unreadNotifications > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                '$_unreadNotifications',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.work_outline,
                          iconBg: const Color(0xFFEDE7FB),
                          iconColor: const Color(0xFF7C5CE0),
                          value: '$_totalProjects',
                          label: 'Total projets',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.show_chart,
                          iconBg: const Color(0xFFE5F5E9),
                          iconColor: const Color(0xFF3A9B54),
                          value: '${(_avgProgress * 100).round()}%',
                          label: 'Avancement moyen',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people_outline,
                          iconBg: const Color(0xFFE3F0FB),
                          iconColor: const Color(0xFF2E7CD6),
                          value: '$_teamMembers',
                          label: 'Membres d\'équipe',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle_outline,
                          iconBg: const Color(0xFFFDF0DE),
                          iconColor: _adaiOrange,
                          value: '$_totalTasks',
                          label: 'Tâches totales',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Liste des projets',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: afficher tous les projets
                        },
                        child: const Text(
                          'Voir tout',
                          style: TextStyle(color: Color(0xFF7C5CE0), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final project in _projects) _ProjectCard(project: project),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProjetDetailScreen(projectName: project.name),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: project.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    project.letter,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        project.description,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, size: 18, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  height: 26,
                  width: (project.memberAvatarUrls.length +
                          (project.extraMembersCount > 0 ? 1 : 0)) *
                          16.0 +
                      10,
                  child: Stack(
                    children: [
                      for (int i = 0; i < project.memberAvatarUrls.length; i++)
                        Positioned(
                          left: i * 16.0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 11,
                              backgroundImage: NetworkImage(project.memberAvatarUrls[i]),
                            ),
                          ),
                        ),
                      if (project.extraMembersCount > 0)
                        Positioned(
                          left: project.memberAvatarUrls.length * 16.0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 11,
                              backgroundColor: Colors.grey.shade200,
                              child: Text(
                                '+${project.extraMembersCount}',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${(project.progress * 100).round()}%',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: project.progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation(project.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
