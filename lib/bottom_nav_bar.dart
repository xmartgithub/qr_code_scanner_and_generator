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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF1139a0),
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(
          color: Colors.white,
          letterSpacing: 1,
        ),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code, color: Colors.white),
            label: 'Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, color: Colors.white),
            label: 'Scanner',
          ),
        ],
      ),
    );
  }
}
