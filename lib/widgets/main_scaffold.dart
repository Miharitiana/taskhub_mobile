import 'package:flutter/material.dart';

import '../screens/flow2/tasklist_screen.dart';
import '../screens/flow3/conversationList_screen.dart';
import '../screens/flow4/profilUser_screen.dart';
import '../screens/flow4/resumeIA_screen.dart';
import '../screens/flow5/projetList_screen.dart';
import '../screens/flow6/pointage_screen.dart';




const _adaiOrange = Color(0xFFB5651D);

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static const _pages = [
    ResumeIAScreen(),
    ProjetListScreen(),
    TaskListScreen(),
    ConversationListScreen(), // TODO: ChatScreen réel
    PointageScreen(),
    ProfilUserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _adaiOrange,
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'Résumé IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            label: 'Projets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            label: 'Pointage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
