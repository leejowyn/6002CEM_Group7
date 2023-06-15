import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/pages/home.dart';
import '../colors.dart';

class NavigationPage extends StatefulWidget {
  static String routeName = '/navigationPage';
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text(
      "Explore",
      style: optionStyle,
    ),
    Text(
      "Bookmark",
      style: optionStyle,
    ),
    Text(
      "Scheduled",
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  color: primary,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: GNav(
                      backgroundColor: primary,
                      color: Colors.white,
                      activeColor: Colors.white,
                      tabBackgroundColor: primary.shade400,
                      gap: 8,
                      padding: EdgeInsets.all(13),
                      tabs: const [
                        GButton(icon: Icons.home_filled, text: "Home"),
                        GButton(icon: Icons.explore, text: "Explore"),
                        GButton(
                            icon: Icons.bookmark_add_outlined,
                            text: "Bookmark"),
                        GButton(
                            icon: Icons.schedule_outlined, text: "Scheduled"),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
