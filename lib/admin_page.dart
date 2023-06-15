import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:trip_planner/admin_profile.dart';
import 'package:trip_planner/dashboard.dart';
import 'package:trip_planner/list_destination.dart';
import 'package:trip_planner/colors.dart';
import 'package:firebase_core/firebase_core.dart';

class AdminPage extends StatefulWidget {
  static String routeName = '/adminPage';
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ListDestination(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          child: Container(
            color: primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav(
                backgroundColor: primary,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: primary.shade400,
                gap: 8,
                padding: const EdgeInsets.all(13),
                tabs: const [
                  GButton(
                    icon: Icons.dashboard
                      ,text:"Dashboard"
                  ),
                  GButton(icon: Icons.add_location_alt,text:"Add Destination"),
                  GButton(icon: Icons.person,text:"Profile"),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index){
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
