import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/pages/user_login.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserRegisterPage extends StatefulWidget {
  static String routeName = '/userRegisterPage';
  const UserRegisterPage({Key? key,}) : super(key: key);

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
    try{
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
          Fluttertoast.showToast(
            msg: "Register successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // redirect to login
          Navigator.of(context).pushNamed(
            UserLoginPage.routeName,
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
        print('Failed to retrieve user UID');
      }

      // pop the loading circle
      // Navigator.pop(context);
      // print("register can liao!!");
      // final user = FirebaseAuth.instance.currentUser!;
      // print(user.uid);

      //pop loading circle
      if(context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //show error to user
      AlertDialogError(errDesc: e.code);
    }

  }
  //display a dialog message
  void displayMessage(String message){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text(message),
    ),
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
                        icon: Icon(Icons.arrow_back),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
                        child: Text("SignUp as User",
                            style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
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
                        errorText: emailValid? null:"This field is empty",
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        errorText: passwordValid? null:"This field is empty",
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5.0,
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
                              setState(() {
                              emailValid = emailController.text.isEmpty ? false : true;
                              passwordValid = passwordController.text.isEmpty ? false : true;
                              });
                              if (emailValid && passwordValid) {
                              signUp(context);}
                            },
                            child: Text(
                                'Register',
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Go Back',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
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
