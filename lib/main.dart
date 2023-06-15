import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/add_destination.dart';
import 'package:trip_planner/admin_page.dart';
import 'package:trip_planner/colors.dart';
import 'package:trip_planner/list_destination.dart';
import 'package:trip_planner/list_detail_page.dart';
import 'package:trip_planner/pages/admin_login.dart';
import 'package:trip_planner/pages/admin_profile.dart';
import 'package:trip_planner/pages/auth_page.dart';
import 'package:trip_planner/pages/home.dart';
import 'package:trip_planner/pages/user_login.dart';
import 'package:trip_planner/pages/navigation_page.dart';
import 'package:trip_planner/pages/user_profile.dart';
import 'package:trip_planner/pages/user_register.dart';
import 'package:trip_planner/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Trip Planner Admin',
      theme: ThemeData(
        //primarySwatch: primary,
        colorSchemeSeed: const Color(0xFF0F3C4D), useMaterial3: true,
      ),
      initialRoute: AuthPage.routeName,
      routes: {
        AdminPage.routeName: (context) => const AdminPage(),
        ListDestination.routeName: (context) => const ListDestination(),
        AddDestination.routeName: (context) => const AddDestination(),
        ListDetailPage.routeName: (context) => const ListDetailPage(),
        SplashPage.routeName:(context)=> SplashPage(),
        AuthPage.routeName:(context)=> AuthPage(),
        AdminLoginPage.routeName:(context)=> AdminLoginPage(),
        HomePage.routeName:(context)=> HomePage(),
        UserRegisterPage.routeName:(context)=> UserRegisterPage(),
        UserLoginPage.routeName:(context)=> UserLoginPage(),
        UserProfilePage.routeName: (context)=> UserProfilePage(),
        NavigationPage.routeName: (context)=> NavigationPage(),
        AdminProfilePage.routeName:(context) => AdminProfilePage(),
      },
    );
  }
}


