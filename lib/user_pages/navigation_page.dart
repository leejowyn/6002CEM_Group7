import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/explore.dart';
import 'package:trip_planner/user_pages/home.dart';
import 'package:trip_planner/user_pages/my_trip_listing.dart';
import 'package:trip_planner/user_pages/user_profile.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';
import '../colors.dart';

class NavigationPage extends StatefulWidget {
  static String routeName = '/navigationPage';
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Explore(),
    MyTripListing(),
  ];

  // get user detail from database
  getUserDetail() async {
    var ref = FirebaseDatabase.instance.ref();
    var uid = currentUser.uid;
    var snapshot = await ref.child('User/$uid').get();
    return snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF7F7F7),
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16, left: 26.0),
          child: Row(
            children: [
              Text(
                "Hello, ",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18
                ),
              ),
              FutureBuilder(
                future: getUserDetail(), // get and display name of user
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    Map user = snapshot.data as Map;

                   return Text(
                     user['name'],
                     style: const TextStyle(
                         fontWeight: FontWeight.bold,
                         color: primary,
                         fontSize: 18
                     ),
                   );
                  } else if (snapshot.hasError) {
                    return AlertDialogError(errDesc: snapshot.error.toString());
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, right: 40.0), // Add right padding to the icon
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  UserProfilePage.routeName,
                );
              },
              child: CircleAvatar(
                backgroundColor: primary.shade50,
                radius: 20,
                child: Icon(
                  Icons.person,
                  color: primary.shade400,
                  size: 28,
                ),
              ),
            ),
          )
        ],
      ),
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
                      padding: const EdgeInsets.all(13),
                      tabs: const [
                        GButton(icon: Icons.home_filled, text: "Home"),
                        GButton(icon: Icons.explore, text: "Explore"),
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
