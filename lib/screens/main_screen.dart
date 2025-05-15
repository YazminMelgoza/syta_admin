import 'package:syta_admin/screens/home_screen.dart';
import 'package:syta_admin/screens/check_inspections.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/client_list.dart';
import 'package:syta_admin/screens/update_availability.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final screens = [const CheckInspections(), const ClientList(),  const UpdateAvail()];

    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 0,
        selectedItemColor: const Color(0xFF1A1A77),
        unselectedItemColor: const Color(0xFF333333),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.car_repair_outlined),
            activeIcon: const Icon(Icons.car_repair),
            label: 'Revisiones',
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'Clientes',
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: 'Disponibilidad',
            backgroundColor: const Color(0xFFF5F5F5),
          ),
        ],
      ),
    );
  }
}

