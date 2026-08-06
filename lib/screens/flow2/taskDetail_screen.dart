import 'package:flutter/material.dart';

import 'taskComment_screen.dart';
import '../../services/task_service.dart';
import '../../models/task.dart' as api;

const _adaiOrange = Color(0xFFB5651D);
const _adaiBrown = Color(0xFF3E2B1F);

class ChecklistItem {
  final String label;
  bool done;

  ChecklistItem({required this.label, this.done = false});
}

class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool _descriptionExpanded = true;
  bool _isLoading = true;
  String? _errorMessage;
  api.Task? _task;

  final taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _loadDetailsTasks();
  }

  Future<void> _loadDetailsTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final task = await taskService.getTaskById(widget.taskId.toString());
      if (!mounted) return;
      setState(() {
        _task = task;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  final List<ChecklistItem> _checklist = [
    ChecklistItem(label: 'Créer la vue UI', done: true),
    ChecklistItem(label: 'Intégrer les champs email & mot de passe', done: true),
    ChecklistItem(label: 'Intégrer connexion biométrique'),
    ChecklistItem(label: 'Gérer les erreurs de connexion'),
    ChecklistItem(label: 'Tests unitaires'),
  ];

  int get _doneCount => _checklist.where((item) => item.done).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage != null)
              Expanded(
                child: Center(
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
                          onPressed: _loadDetailsTasks,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _task!.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F0FB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _task!.status,
                            style: const TextStyle(
                              color: Color(0xFF2E7CD6),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.flag, size: 15, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          _task!.priority,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'Projet',
                            value: _task!.projectName ?? 'Projet #${_task!.projectId}',
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          _InfoRow(
                            label: 'Sprint',
                            value: _task!.sprintName ??
                                (_task!.sprintId != null ? 'Sprint #${_task!.sprintId}' : 'Aucun'),
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          _InfoRow(
                            label: 'Deadline',
                            value: _task!.deadline != null
                                ? '${_task!.deadline!.toLocal().day.toString().padLeft(2, '0')}/'
                                    '${_task!.deadline!.toLocal().month.toString().padLeft(2, '0')}/'
                                    '${_task!.deadline!.toLocal().year}'
                                : 'Non définie',
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          _InfoRow(
                            label: 'Assigné à',
                            value: _task!.assignedToName ?? 'Utilisateur #${_task!.assignedToId}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    InkWell(
                      onTap: () => setState(() => _descriptionExpanded = !_descriptionExpanded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            _descriptionExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                    if (_descriptionExpanded) ...[
                      const SizedBox(height: 8),
                      Text(
                        _task!.description ?? 'Aucune description',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4),
                      ),
                    ],
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Checklist',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$_doneCount/${_checklist.length}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final item in _checklist)
                      CheckboxListTile(
                        value: item.done,
                        onChanged: (value) {
                          setState(() => item.done = value ?? false);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: _adaiOrange,
                        title: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14,
                            color: item.done ? Colors.grey.shade500 : Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: démarrer la tâche
                  },
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: const Text(
                    'Commencer',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7CD6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 48,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TaskCommentScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.more_horiz, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _InfoRow({required this.label, this.value, this.valueWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          valueWidget ??
              Text(
                value ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
        ],
      ),
    );
  }
}
