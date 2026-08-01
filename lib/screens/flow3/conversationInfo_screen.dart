import 'package:flutter/material.dart';

const _adaiOrange = Color(0xFFB5651D);

enum MemberStatus { enLigne, absent, horsLigne }

class ProjectMember {
  final String name;
  final String role;
  final String avatarUrl;
  final MemberStatus status;

  const ProjectMember({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.status,
  });
}

class ConversationInfoScreen extends StatelessWidget {
  final String projectName;
  final String projectDescription;
  final int totalDocuments;
  final List<ProjectMember> members;

  const ConversationInfoScreen({
    super.key,
    this.projectName = 'Mobile App',
    this.projectDescription = 'Développement de l\'application mobile pour nos utilisateurs.',
    this.totalDocuments = 8,
    this.members = const [
      ProjectMember(
        name: 'Mirindra R.',
        role: 'Chef de projet',
        avatarUrl: 'https://i.pravatar.cc/100?img=12',
        status: MemberStatus.enLigne,
      ),
      ProjectMember(
        name: 'Tovo M.',
        role: 'Développeur',
        avatarUrl: 'https://i.pravatar.cc/100?img=51',
        status: MemberStatus.enLigne,
      ),
      ProjectMember(
        name: 'Aina R.',
        role: 'Designer UI/UX',
        avatarUrl: 'https://i.pravatar.cc/100?img=45',
        status: MemberStatus.enLigne,
      ),
      ProjectMember(
        name: 'Rakoto N.',
        role: 'QA Engineer',
        avatarUrl: 'https://i.pravatar.cc/100?img=33',
        status: MemberStatus.absent,
      ),
      ProjectMember(
        name: 'Rija S.',
        role: 'Marketing',
        avatarUrl: 'https://i.pravatar.cc/100?img=47',
        status: MemberStatus.horsLigne,
      ),
    ],
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
          'Info projet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A9B54),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.phone_iphone, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    projectName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    projectDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: naviguer vers les documents du projet
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF0DE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.folder_outlined, size: 18, color: _adaiOrange),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Documents du projet',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$totalDocuments fichiers partagés',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Membres (${members.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 12),
            for (final member in members) _MemberTile(member: member),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final ProjectMember member;

  const _MemberTile({required this.member});

  ({Color color, String label}) get _statusStyle {
    switch (member.status) {
      case MemberStatus.enLigne:
        return (color: const Color(0xFF3A9B54), label: 'En ligne');
      case MemberStatus.absent:
        return (color: const Color(0xFFE0A527), label: 'Absent');
      case MemberStatus.horsLigne:
        return (color: Colors.grey.shade400, label: 'Hors ligne');
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(member.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  member.role,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                status.label,
                style: TextStyle(color: status.color, fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
