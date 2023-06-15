import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/navigation_page.dart';
import 'package:trip_planner/user_pages/user_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 35,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Hallo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20), // Add spacing between the text and icon
              Padding(
                padding: EdgeInsets.only(top: 16.0, right: 10.0), // Add right padding to the icon
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        UserProfilePage.routeName,
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE6E6E6),
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      color: Color(0xffCCCCCC),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


