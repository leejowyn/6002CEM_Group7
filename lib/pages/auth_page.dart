import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/pages/admin_profile.dart';
import 'package:trip_planner/pages/navigation_page.dart';
import 'package:trip_planner/pages/user_profile.dart';
import 'package:trip_planner/pages/splash_page.dart';

class AuthPage extends StatelessWidget {
  static String routeName = '/authPage';
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          //Is logged in
          if(snapshot.hasData){
           //Identify user or admin
            final user = FirebaseAuth.instance.currentUser!;
            String uid = user.uid;
            DatabaseReference userRef = FirebaseDatabase.instance.ref('User/$uid');
            userRef.onValue.listen((DatabaseEvent event) {
              if (event.snapshot.value != null) {
                Navigator.of(context).pushNamed(
                  NavigationPage.routeName,
                );
                // return NavigationPage();
              }
              else {
                Navigator.of(context).pushNamed(
                  AdminProfilePage.routeName,
                );
                // return AdminProfilePage();
              }
            });
            return SplashPage();
          }
          else {
            //If Not logged in
            return SplashPage();
          }
        },
      ),
    );
  }
}
