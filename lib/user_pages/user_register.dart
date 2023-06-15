import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/home.dart';
import 'package:trip_planner/user_pages/navigation_page.dart';
import 'package:trip_planner/user_pages/user_login.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserRegisterPage extends StatefulWidget {
  static String routeName = '/userRegisterPage';
  const UserRegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool emailValid = true;
  bool passwordValid = true;

  //sign user
  void signUp(context) async {
    //show loading cicle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //try creating the user
    try {
      //create the user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String? uid = userCredential.user?.uid;

      if (uid != null) {
        // insert new user to database
        DatabaseReference dbRef = FirebaseDatabase.instance.ref('User/$uid');

        Map<String, String> user = {
          'name': emailController.text.split('@')[0], // initially username
        };

        dbRef.set(user).then((value) {
          // Display success toast
          showToastMessage("You account has been successfully registered");

          // redirect to home page
          Navigator.of(context).pushNamed(
            HomePage.routeName,
          );
        }).catchError((error) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogError(errDesc: error);
            },
          );
        });
      } else {
        showToastMessage("Error occur. Failed to retrieve user UID.");
      }

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      if (e.code == "invalid-email") {
        showToastMessage("The e-mail that you've entered is invalid");
      } else if (e.code == "weak-password") {
        showToastMessage("The password must be at least 6 characters");
      } else {
        showToastMessage(e.code);
      }
      //show error to user
    }
  }

  // error message toast
  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 110, 0, 0),
                    child: const Text("SignUp as User",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 35, left: 20, right: 30),
          child: Column(
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'EMAIL',
                  errorText: emailValid ? null : "This field is empty",
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'PASSWORD',
                  errorText: passwordValid ? null : "This field is empty",
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                child: Material(
                  child: Center(
                      child: FilledButton(
                          onPressed: () {
                            setState(() {
                              emailValid =
                                  emailController.text.isEmpty ? false : true;
                              passwordValid = passwordController.text.isEmpty
                                  ? false
                                  : true;
                            });
                            if (emailValid && passwordValid) {
                              signUp(context);
                            }
                          },
                          child: const Text(
                            'Register',
                          ),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 50),
                            ),
                          ))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Already have an account? Login',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        )
      ],
    ));
  }
}
