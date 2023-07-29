import 'package:flutter/material.dart';
import 'package:qr_code_scanner_and_generator/pages/qr_create_page.dart';
import 'package:qr_code_scanner_and_generator/pages/qr_scan_page.dart';

class MyNavBar extends StatefulWidget {
  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int currentIndex = 0;

  List listOfPages = [
    QRCreatePage(),
    QRScanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listOfPages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.qr_code),
            label: 'Generator',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
        ],
      ),
    );
  }
}
