import 'package:flutter/material.dart';

import 'taskDetail_screen.dart';

const _adaiOrange = Color(0xFFB5651D);
const _adaiBrown = Color(0xFF3E2B1F);

enum TaskStatus { aFaire, enCours, aTester, termine }

class Task {
  final String title;
  final String project;
  final String deadline;
  final TaskStatus status;
  final String avatarUrl;

  const Task({
    required this.title,
    required this.project,
    required this.deadline,
    required this.status,
    required this.avatarUrl,
  });
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskStatus? _selectedFilter; // null = "Toutes"

  static const _tasks = [
    Task(
      title: 'Intégration de l\'écran de connexion',
      project: 'Projet Mobile App',
      deadline: '28/06/2026',
      status: TaskStatus.aFaire,
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
    ),
    Task(
      title: 'API gestion des utilisateurs',
      project: 'Projet Backend',
      deadline: '01/07/2026',
      status: TaskStatus.enCours,
      avatarUrl: 'https://i.pravatar.cc/100?img=32',
    ),
    Task(
      title: 'Correction bug formulaire',
      project: 'Projet Web Platform',
      deadline: '25/06/2026',
      status: TaskStatus.aTester,
      avatarUrl: 'https://i.pravatar.cc/100?img=51',
    ),
    Task(
      title: 'Design écran tableau de bord',
      project: 'Projet Dashboard',
      deadline: '20/06/2026',
      status: TaskStatus.termine,
      avatarUrl: 'https://i.pravatar.cc/100?img=45',
    ),
  ];

  List<Task> get _filteredTasks {
    if (_selectedFilter == null) return _tasks;
    return _tasks.where((t) => t.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes tâches',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _adaiBrown,
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
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChip(
                label: 'Toutes',
                selected: _selectedFilter == null,
                onTap: () => setState(() => _selectedFilter = null),
              ),
              _FilterChip(
                label: 'À faire',
                selected: _selectedFilter == TaskStatus.aFaire,
                onTap: () => setState(() => _selectedFilter = TaskStatus.aFaire),
              ),
              _FilterChip(
                label: 'En cours',
                selected: _selectedFilter == TaskStatus.enCours,
                onTap: () => setState(() => _selectedFilter = TaskStatus.enCours),
              ),
              _FilterChip(
                label: 'À tester',
                selected: _selectedFilter == TaskStatus.aTester,
                onTap: () => setState(() => _selectedFilter = TaskStatus.aTester),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredTasks.length,
            itemBuilder: (context, index) {
              return _TaskCard(task: _filteredTasks[index]);
            },
          ),
        ),
      ],
    )
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

class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  ({String label, Color bg, Color fg}) get _statusStyle {
    switch (task.status) {
      case TaskStatus.aFaire:
        return (label: 'À faire', bg: const Color(0xFFE3F0FB), fg: const Color(0xFF2E7CD6));
      case TaskStatus.enCours:
        return (label: 'En cours', bg: const Color(0xFFE5F5E9), fg: const Color(0xFF3A9B54));
      case TaskStatus.aTester:
        return (label: 'À tester', bg: const Color(0xFFFDF0DE), fg: _adaiOrange);
      case TaskStatus.termine:
        return (label: 'Terminé', bg: Colors.grey.shade200, fg: Colors.grey.shade700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TaskDetailScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.folder_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        task.project,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        'Deadline: ${task.deadline}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: status.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(
                      color: status.fg,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(task.avatarUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
