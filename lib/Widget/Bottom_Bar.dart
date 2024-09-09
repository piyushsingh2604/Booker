import 'package:booker/Payments/Payments.dart';
import 'package:booker/Screens/Fav_Screen.dart';
import 'package:booker/Screens/Home_Screen.dart';
import 'package:booker/Screens/Profile_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class BottomBar extends StatefulWidget {
  final String name;
  final String email;
  final String number;

  BottomBar({required this.name, required this.email, required this.number});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final iconList = <IconData>[
    Icons.home,
    Icons.person,
  ];

  late List<Widget> _pages;
  ////////////////

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Initialize _pages with widget properties
    _pages = [
      HomeScreen(),
      ProfileScreen(
          email: widget.email, name: widget.name), // Access widget properties
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payments(),
              ));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return AnimatedBottomNavigationBar(
            icons: iconList,
            activeIndex: _currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: _onTabTapped,
            iconSize: 24 + _animation.value * 6, // Increase size with animation
          );
        },
      ),
    );
  }
}
