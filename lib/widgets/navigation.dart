import 'package:flutter/material.dart';

import '../pages/UserProfil.dart';
import '../pages/contact.dart';
import '../pages/message.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Message()));
            break;
          case 1:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Contact()));
            break;
          case 2:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Userprofil()));
            break;
        }
      },
      indicatorColor: Colors.red[300],
      selectedIndex: currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(Icons.contact_page),
          label: 'Contact',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}