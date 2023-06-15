import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/splash_page.dart';
import 'package:trip_planner/widgets/text_box.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';

class UserProfilePage extends StatefulWidget {
  static String routeName = '/userProfilePage';
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
// User
  final currentUser = FirebaseAuth.instance.currentUser!;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('User');

  // Edit field
  Future<void> editField(String field) async {
    // Implement the logic to edit the field here
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit" + field,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          //save button
          TextButton(
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                //update in database
                Map<String, String> valueToUpdate = {
                  'name': newValue, // initially username
                };

                dbRef
                    .child(currentUser.uid)
                    .update(valueToUpdate)
                    .then((value) {
                  setState(() {});
                });
              }),
        ],
      ),
    );
  }

  // Sign-out function
  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed(
      SplashPage.routeName,
    );
  }

  // get user detail from database
  getUserDetail() async {
    var ref = FirebaseDatabase.instance.ref();
    var uid = currentUser.uid;
    var snapshot = await ref.child('User/$uid').get();
    print(snapshot.value);
    return snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("User Profile"),
          backgroundColor: Colors.grey[300],
          actions: [
            //sign out button
            IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
          ],
        ),
        body: FutureBuilder(
          future: getUserDetail(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              Map user = snapshot.data as Map;

              // display user detail
              return ListView(
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

                  // User details
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  // Name
                  MyTextBox(
                    text: user['name'],
                    sectionName: 'Name',
                    onPressed: () => editField('name'),
                    canEdit: true,
                  ),

                  // Email
                  MyTextBox(
                    text: currentUser.email!,
                    sectionName: 'Email',
                    onPressed: () => editField('email'),
                    canEdit: false,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialogError(errDesc: snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
