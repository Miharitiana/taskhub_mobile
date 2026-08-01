import 'package:flutter/material.dart';

const _adaiOrange = Color(0xFFB5651D);
const _purple = Color(0xFF7C5CE0);

class TeamMemberPreview {
  final String name;
  final String role;
  final String avatarUrl;

  const TeamMemberPreview({
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}

class ProjetDetailScreen extends StatelessWidget {
  final String projectName;
  final String status;
  final String description;
  final double progress;
  final int totalSprints;
  final int totalTasks;
  final int totalMembers;
  final String startDate;
  final List<TeamMemberPreview> members;
  final int extraMembersCount;

  const ProjetDetailScreen({
    super.key,
    this.projectName = 'Plateforme ADAI',
    this.status = 'En cours',
    this.description =
        'Développement de la plateforme de gestion de projet intelligente',
    this.progress = 0.75,
    this.totalSprints = 8,
    this.totalTasks = 54,
    this.totalMembers = 12,
    this.startDate = '12 janv. 2025',
    this.members = const [
      TeamMemberPreview(
        name: 'Sarah K.',
        role: 'Chef de projet',
        avatarUrl: 'https://i.pravatar.cc/100?img=45',
      ),
      TeamMemberPreview(
        name: 'Yassine B.',
        role: 'Développeur',
        avatarUrl: 'https://i.pravatar.cc/100?img=51',
      ),
      TeamMemberPreview(
        name: 'Fatima A.',
        role: 'Designer',
        avatarUrl: 'https://i.pravatar.cc/100?img=32',
      ),
      TeamMemberPreview(
        name: 'Omar H.',
        role: 'QA Engineer',
        avatarUrl: 'https://i.pravatar.cc/100?img=13',
      ),
    ],
    this.extraMembersCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Détails du projet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              // TODO: afficher plus d'options
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'P',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                projectName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Color(0xFF3A9B54),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Avancement du projet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _purple),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation(_purple),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Progression globale',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.assignment_outlined,
                    iconBg: const Color(0xFFE3F0FB),
                    iconColor: const Color(0xFF2E7CD6),
                    value: '$totalSprints',
                    label: 'Sprints',
                    caption: 'Total sprints',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_outline,
                    iconBg: const Color(0xFFE5F5E9),
                    iconColor: const Color(0xFF3A9B54),
                    value: '$totalTasks',
                    label: 'Tâches',
                    caption: 'Total tâches',
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
                    iconBg: const Color(0xFFFDF0DE),
                    iconColor: _adaiOrange,
                    value: '$totalMembers',
                    label: 'Membres',
                    caption: 'Dans le projet',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today_outlined,
                    iconBg: const Color(0xFFFCE4F1),
                    iconColor: const Color(0xFFE0709B),
                    value: startDate,
                    label: 'Date de début',
                    caption: 'Début du projet',
                    valueFontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'La plateforme ADAI est une solution complète de gestion de projets qui permet aux équipes de collaborer efficacement, suivre l\'avancement des tâches et générer des rapports intelligents grâce à l\'IA.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13.5, height: 1.5),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Membres de l\'équipe',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: afficher tous les membres
                  },
                  child: const Text(
                    'Voir tout',
                    style: TextStyle(color: _purple, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final member in members)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(member.avatarUrl),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            member.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          Text(
                            member.role,
                            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  if (extraMembersCount > 0)
                    Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _purple, width: 1.5, style: BorderStyle.solid),
                          ),
                          child: Text(
                            '+$extraMembersCount',
                            style: const TextStyle(color: _purple, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Plus de\nmembres',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;
  final String caption;
  final double valueFontSize;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.caption,
    this.valueFontSize = 18,
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
            style: TextStyle(fontSize: valueFontSize, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Text(
            caption,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
