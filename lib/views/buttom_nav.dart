import 'package:flutter/material.dart';
import 'package:laundry_jaya/utils/role_checker.dart';
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
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() async {
    final isOwner = await RoleChecker.isOwner();

    setState(() {
      _widgetOptions = isOwner
          ? <Widget>[
              OwnerDashboard(),
              RiwayatPesananScreen(),
              ProfileAPIScreen(),
            ]
          : <Widget>[HomeScreen(), RiwayatPesananScreen(), ProfileAPIScreen()];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_widgetOptions.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        ],
      ),
    );
  }
}
