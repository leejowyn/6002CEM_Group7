import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_planner/pages/home.dart';
import 'package:trip_planner/pages/splash_page.dart';

import 'admin_login.dart';
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
      // pop the loading circle
      Navigator.pop(context);
      print("logged in YAY");
      final user = FirebaseAuth.instance.currentUser!;
      print(user.uid);

      // Display success toast
      Fluttertoast.showToast(
        msg: "Login successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Redirect to homepage
      Navigator.pushNamed(context, HomePage.routeName);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        // show wrong email error
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        // show wrong password error
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message toast
  void wrongEmailMessage() {
    Fluttertoast.showToast(
      msg: "Incorrect Email",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // wrong password message toast
  void wrongPasswordMessage() {
    Fluttertoast.showToast(
      msg: "Incorrect Password",
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
                        icon: Icon(Icons.arrow_back),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
                        child: Text(
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
              padding: EdgeInsets.only(top: 35, left: 20, right: 30),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'EMAIL',
                      errorText: emailValid? null : "This field is empty",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      errorText: passwordValid ? null : "This field is empty",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    alignment: Alignment(1, 0),
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: InkWell(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 40,
                    child: Material(
                      child: Center(
                        child: FilledButton(
                          onPressed: () {
                              setState( () {
                            emailValid = emailController.text.isEmpty ? false : true;
                            passwordValid = passwordController.text.isEmpty ? false : true;
                            });
                            if (emailValid && passwordValid) {
                            signUserIn(context);}
                          },
                          child: Text(
                            'Login',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            UserRegisterPage.routeName,
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     TextButton(
        //       onPressed: () {
        //         Navigator.of(context).pushNamed(
        //           AdminLoginPage.routeName,
        //         );
        //       },
        //       child: Text(
        //         'login as admin',
        //         style: TextStyle(
        //             color: Colors.blueGrey,
        //             fontFamily: 'Montserrat',
        //             fontWeight: FontWeight.bold,
        //             decoration: TextDecoration.underline),
        //       ),
        //     )
        //   ],
        // )
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AdminLoginPage.routeName,
                );
              },
              child: Text(
                'Login as Admin',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            )
        ],
      ),

    );
  }
}
