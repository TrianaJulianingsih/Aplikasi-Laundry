import 'package:flutter/material.dart';
import 'package:laundry_jaya/views/home.dart';
import 'package:laundry_jaya/views/owner_screen.dart';
import 'package:laundry_jaya/views/profile_screen.dart';
import 'package:laundry_jaya/views/riwayat_screen.dart';

class ButtomNav extends StatefulWidget {
  const ButtomNav({super.key});
  static const id = "/buttomNav";

  @override
  State<ButtomNav> createState() => _ButtomNavState();
}

class _ButtomNavState extends State<ButtomNav> {
  // bool appBar = true;
  bool isCheck = false;
  bool isCheckSwitch = false;
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    RiwayatPesananScreen(),
    ProfileAPIScreen(),
    OwnerDashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Dashbord"), backgroundColor: Colors.blue),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/home1.png", width: 30, height: 30),
            activeIcon: Image.asset(
              "assets/images/home2.png",
              width: 30,
              height: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/delivery.png",
              width: 30,
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/images/delivery (1).png",
              width: 30,
              height: 30,
            ),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/user.png", width: 30, height: 30),
            activeIcon: Image.asset(
              "assets/images/user (1).png",
              width: 30,
              height: 30,
            ),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/admin1.png",
              width: 30,
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/images/admin2.png",
              width: 30,
              height: 30,
            ),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 12, 92, 65),
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
