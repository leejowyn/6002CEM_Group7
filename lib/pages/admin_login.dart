import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_planner/admin_page.dart';
import 'package:trip_planner/pages/admin_profile.dart';
import 'package:trip_planner/pages/home.dart';
import 'package:trip_planner/pages/splash_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AdminLoginPage extends StatefulWidget {
  static String routeName = '/adminLoginPage';
  AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  bool emailValid = true;

  bool passwordValid = true;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // sign in method
  void signAdminIn(BuildContext context) async {

    // try sign in
    try {
      // show loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

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

      // Redirect to
      Navigator.of(context).pushNamed(
        AdminPage.routeName,
      );

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
    return Scaffold(
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
                      child: const Text(
                        "Hello Admin",
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

                    errorText: emailValid ? null: "This field is empty",

                    labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',

                    errorText: passwordValid ? null : "This field is empty",

                    errorText: passwordValid ? null: "This field is empty",

                    labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  alignment: const Alignment(1, 0),
                  padding: const EdgeInsets.only(top: 15, left: 20),

                  child: const InkWell(
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
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 40,
                  child: Material(
                    child: Center(
                      child: FilledButton(
                        onPressed: () {

                          setState(() {
                            emailValid =
                                emailController.text.isEmpty ? false : true;
                            passwordValid =
                                passwordController.text.isEmpty ? false : true;
                          });

                          if (emailValid && passwordValid) {
                            signAdminIn(context);
                          
                          }

                                setState(() {
                                emailValid = emailController.text.isEmpty ? false : true;
                                passwordValid = passwordController.text.isEmpty ? false : true;
                                });

                                if (emailValid && passwordValid) {
                          Navigator.pushNamed(context, AdminPage.routeName);}

                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
