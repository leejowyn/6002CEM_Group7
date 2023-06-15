import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/admin_pages/admin_login.dart';
import 'package:trip_planner/admin_pages/admin_profile.dart';
import 'package:trip_planner/auth_page.dart';
import 'package:trip_planner/user_pages/home.dart';
import 'package:trip_planner/user_pages/user_login.dart';
import 'package:trip_planner/user_pages/navigation_page.dart';
import 'package:trip_planner/user_pages/user_profile.dart';
import 'package:trip_planner/user_pages/user_register.dart';
import 'package:trip_planner/user_pages/splash_page.dart';
import 'admin_pages/add_destination.dart';
import 'package:trip_planner/admin_pages/admin_page.dart';
import 'admin_pages/list_destination.dart';
import 'package:trip_planner/admin_pages/list_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff0f3C4D),useMaterial3:true
      ),
      initialRoute: AuthPage.routeName,
      routes: {
        SplashPage.routeName:(context)=> const SplashPage(),
        AuthPage.routeName:(context)=> const AuthPage(),
        AdminLoginPage.routeName:(context)=> AdminLoginPage(),
        HomePage.routeName:(context)=> const HomePage(),
        UserRegisterPage.routeName:(context)=> const UserRegisterPage(),
        UserLoginPage.routeName:(context)=> UserLoginPage(),
        UserProfilePage.routeName: (context)=> const UserProfilePage(),
        NavigationPage.routeName: (context)=> const NavigationPage(),
        AdminProfilePage.routeName:(context) => const AdminProfilePage(),
        AdminPage.routeName: (context) => const AdminPage(),
        ListDestination.routeName: (context) => const ListDestination(),
        AddDestination.routeName: (context) => const AddDestination(),
        ListDetailPage.routeName: (context) => const ListDetailPage(),
      },
    );
  }
}
