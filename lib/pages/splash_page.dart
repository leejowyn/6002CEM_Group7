import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/colors.dart';
import 'package:trip_planner/pages/admin_login.dart';
import 'package:trip_planner/pages/user_login.dart';

class SplashPage extends StatefulWidget {
  static String routeName = '/splashPage';
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
              opacity: 0.7,
            )),
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 65, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enjoy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "the world!",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                          "Embark on a journey of seamless exploration and create unforgettable memories with our all-inclusive trip planning app, from destination discovery to personalized itineraries and beyond.",
                     style: TextStyle(
                       color: Colors.white.withOpacity(0.7),
                       fontSize: 16,
                       letterSpacing: 1.2,
                     ),
                      ),
                      SizedBox(height: 17),
                      InkWell(onTap: (){
                        Navigator.of(context).pushNamed(
                          UserLoginPage.routeName,
                        );
                      },
                        child: Ink(
                          padding:EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Get Started",
                              style:TextStyle(
                                color: Colors.black54,
                                fontSize:18,)
                          ),
                        ),
                      ),
                    ],
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
