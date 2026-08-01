import 'package:flutter/material.dart';

import 'pointageHistorique_screen.dart';

const _adaiOrange = Color(0xFFB5651D);
const _adaiGreen = Color(0xFF3A9B54);

class TimelineStep {
  final String time;
  final String label;
  final bool isDone;
  final bool isActive;

  const TimelineStep({
    required this.time,
    required this.label,
    this.isDone = false,
    this.isActive = false,
  });
}

class PointageScreen extends StatefulWidget {
  const PointageScreen({super.key});

  @override
  State<PointageScreen> createState() => _PointageScreenState();
}

class _PointageScreenState extends State<PointageScreen> {
  // TODO: remplacer par les vraies données (API pointage)
  final String _date = 'Jeudi 3 Juillet 2026';
  final String _statut = 'EN POSTE';
  final String _debutJournee = '08h02';
  final String _tempsEffectif = '03:45:12';
  final String _tempsEnPause = '45 min en pause';

  final List<TimelineStep> _timeline = const [
    TimelineStep(time: '08h02', label: 'Arrivée', isDone: true),
    TimelineStep(time: '10h15', label: 'Pause', isDone: true, isActive: true),
    TimelineStep(time: '11h00', label: 'Reprise', isDone: true, isActive: true),
    TimelineStep(time: '--:--', label: 'Départ'),
  ];

  void _prendrePause() {
    // TODO: brancher l'action réelle de prise de pause
  }

  void _terminerJournee() {
    // TODO: brancher l'action réelle de fin de journée
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
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://dashboard-wally-process-interne.adaiexpertise.fr/logo_sans_fond.png',
                  ),
                  backgroundColor: Colors.transparent,
                ),
                const Text(
                  'Mon Pointage',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.history, color: Colors.grey.shade700),
                      tooltip: 'Historique des pointages',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PointageHistoriqueScreen(),
                          ),
                        );
                      },
                    ),
                    Icon(Icons.notifications_none, color: Colors.grey.shade700),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    _date,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'STATUT DE LA JOURNÉE',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, size: 8, color: _adaiGreen),
                        const SizedBox(width: 6),
                        Text(
                          _statut,
                          style: const TextStyle(
                            color: _adaiGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Début de journée',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _debutJournee,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        child: VerticalDivider(color: Colors.grey.shade200, width: 1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Temps effectif',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _tempsEffectif,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _adaiOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pause_circle_outline, size: 15, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        _tempsEnPause,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'ACTION DISPONIBLE',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _prendrePause,
                icon: const Icon(Icons.pause_circle_outline, color: _adaiOrange, size: 18),
                label: const Text(
                  'PRENDRE UNE PAUSE',
                  style: TextStyle(color: _adaiOrange, fontSize: 14, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _adaiOrange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _terminerJournee,
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.red, size: 18),
                label: const Text(
                  'TERMINER MA JOURNÉE',
                  style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'TIMELINE DU JOUR',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            _Timeline(steps: _timeline),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const _Timeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: i == 0
                          ? const SizedBox()
                          : Container(
                              height: 2,
                              color: steps[i - 1].isDone ? _stepColor(steps[i - 1]) : Colors.grey.shade300,
                            ),
                    ),
                    _StepDot(step: steps[i]),
                    Expanded(
                      child: i == steps.length - 1
                          ? const SizedBox()
                          : Container(
                              height: 2,
                              color: steps[i].isDone ? _stepColor(steps[i]) : Colors.grey.shade300,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  steps[i].time,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  steps[i].label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Color _stepColor(TimelineStep step) => step.isActive ? _adaiOrange : _adaiGreen;
}

class _StepDot extends StatelessWidget {
  final TimelineStep step;

  const _StepDot({required this.step});

  @override
  Widget build(BuildContext context) {
    if (!step.isDone) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
      );
    }
    final color = step.isActive ? _adaiOrange : _adaiGreen;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: step.isActive ? Colors.white : color,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}
