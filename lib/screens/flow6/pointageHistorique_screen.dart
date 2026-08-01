import 'package:flutter/material.dart';

const _adaiOrange = Color(0xFFB5651D);

class PointageDay {
  final String date;
  final String duration;
  final String pauseInfo;
  final bool isComplete;

  const PointageDay({
    required this.date,
    required this.duration,
    required this.pauseInfo,
    required this.isComplete,
  });
}

class PointageHistoriqueScreen extends StatefulWidget {
  const PointageHistoriqueScreen({super.key});

  @override
  State<PointageHistoriqueScreen> createState() => _PointageHistoriqueScreenState();
}

class _PointageHistoriqueScreenState extends State<PointageHistoriqueScreen> {
  // TODO: remplacer par les vraies données (API pointage)
  final List<PointageDay> _history = const [
    PointageDay(
      date: 'Mercredi 2 Juillet 2026',
      duration: '8h 30min',
      pauseInfo: '1 pause (45 min)',
      isComplete: true,
    ),
    PointageDay(
      date: 'Mardi 1 Juillet 2026',
      duration: '7h 45min',
      pauseInfo: '2 pauses (30 min)',
      isComplete: true,
    ),
    PointageDay(
      date: 'Lundi 30 Juin 2026',
      duration: '5h 20min',
      pauseInfo: '1 pause (20 min)',
      isComplete: false,
    ),
    PointageDay(
      date: 'Vendredi 27 Juin 2026',
      duration: '8h 10min',
      pauseInfo: '1 pause (35 min)',
      isComplete: true,
    ),
    PointageDay(
      date: 'Jeudi 26 Juin 2026',
      duration: '7h 00min',
      pauseInfo: '0 pause',
      isComplete: false,
    ),
    PointageDay(
      date: 'Mercredi 25 Juin 2026',
      duration: '8h 15min',
      pauseInfo: '2 pauses (50 min)',
      isComplete: true,
    ),
    PointageDay(
      date: 'Mardi 24 Juin 2026',
      duration: '6h 40min',
      pauseInfo: '1 pause (30 min)',
      isComplete: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Historique Pointage',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () {
              // TODO: afficher les filtres (période, statut, etc.)
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _history.length,
          itemBuilder: (context, index) => _PointageDayTile(day: _history[index]),
        ),
      ),
    );
  }
}

class _PointageDayTile extends StatelessWidget {
  final PointageDay day;

  const _PointageDayTile({required this.day});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: naviguer vers le détail du pointage de ce jour
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFDF0DE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_today_outlined, size: 18, color: _adaiOrange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        day.pauseInfo,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  day.duration,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: day.isComplete ? const Color(0xFFE5F5E9) : const Color(0xFFFDF0DE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    day.isComplete ? 'Complet' : 'Incomplet',
                    style: TextStyle(
                      color: day.isComplete ? const Color(0xFF3A9B54) : _adaiOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
