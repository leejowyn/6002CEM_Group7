import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_planner/user_pages/home.dart';
import 'package:trip_planner/splash_page.dart';

import '../admin_pages/admin_login.dart';
import 'user_register.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserLoginPage extends StatefulWidget {
  static String routeName = '/userLoginPage';

  UserLoginPage({Key? key}) : super(key: key);

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool emailValid = true;
  bool passwordValid = true;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // sign in method
  void signUserIn(BuildContext context) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Redirect to homepage
      Navigator.pushNamed(context, Home.routeName);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        // show wrong email error
        errorToastMessage("The email that you've entered is incorrect");
      } else if (e.code == 'wrong-password') {
        // show wrong password error
        errorToastMessage("The password that you've entered is incorrect");
      } else {
        errorToastMessage(
            "The email or password that you've entered is incorrect");
      }
    }
  }

  // error message toast
  void errorToastMessage(String message) {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                        child: const Text(
                          "Hello User",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      errorText: passwordValid ? null : "This field is empty",
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
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
                                signUserIn(context);
                              }
                            },
                            child: const Text(
                              'Login',
                            ),
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.infinity, 50),
                              ),
                            )),
                      ),
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
                          Navigator.of(context).pushNamed(
                            UserRegisterPage.routeName,
                          );
                        },
                        child: const Text('Don\'t have an account? Sign Up',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AdminLoginPage.routeName,
              );
            },
            child: const Text(
              'Login as Admin',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
