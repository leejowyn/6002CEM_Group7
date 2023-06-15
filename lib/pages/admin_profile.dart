import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/pages/splash_page.dart';
import 'package:trip_planner/widgets/text_box.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';

class AdminProfilePage extends StatefulWidget {
  static String routeName = '/adminProfilePage';
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
// Admin
  final currentUser = FirebaseAuth.instance.currentUser!;


  // Sign-out function
  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed(
      SplashPage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("Admin Profile"),
          backgroundColor: Colors.grey[300],
          actions: [
            //sign out button

            IconButton(onPressed: signOut, icon: Icon(Icons.logout)),

            IconButton(onPressed: signOut, icon: Icon(Icons.logout,color: Colors.black,)),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 50),

            // Profile pic
            CircleAvatar(
              backgroundColor: Colors.grey[700],
              radius: 50,
              child: Icon(
                Icons.person,
                color: Color(0xffCCCCCC),
                size: 72,
              ),
            ),

            const SizedBox(height: 50),

            // Admin details
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                'My Details',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),

            // Email
            MyTextBox(

              text: currentUser.email!,
              sectionName: 'Email',
              canEdit: false,
            ),
            SizedBox(height: 60),

              text: 'Admin Email',
              sectionName: 'Email',
              canEdit: false,
            ),
            SizedBox(height: 10),
            MyTextBox(
              text: 'Admin Password',
              sectionName: 'Password',
              canEdit: false,
            ),
          ],
        ));
  }
}