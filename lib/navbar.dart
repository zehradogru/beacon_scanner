
import 'package:beacon_project/pages/connected_devices_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/location_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> pages = [
    const HomePage(),
    const ConnectedDevicesPage(),
    const LocationPage(),
  ];
  int current = 0;

  void onTap(int index) {
    setState(() {
      current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[current],

      bottomNavigationBar: Container(
        height: 80.0,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.2, color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(0, Icons.bluetooth_searching_rounded, 'Tarayıcı'),
            _buildNavBarItem(1, Icons.list_alt, 'Bağlı Cihazlar'),
            _buildNavBarItem(2, Icons.location_on, 'Konum'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              icon,
              size:27,
              color: current == index ? Colors.blue : Colors.black26),
          Text(label, style: TextStyle(color: current == index ? Colors.blue : Colors.black26)),
        ],
      ),
    );
  }
}
