import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/pages/admin_login.dart';
import 'package:trip_planner/pages/admin_profile.dart';
import 'package:trip_planner/pages/auth_page.dart';
import 'package:trip_planner/pages/home.dart';
import 'package:trip_planner/pages/user_login.dart';
import 'package:trip_planner/pages/navigation_page.dart';
import 'package:trip_planner/pages/user_profile.dart';
import 'package:trip_planner/pages/user_register.dart';
import 'package:trip_planner/pages/splash_page.dart';
import 'add_destination.dart';
import 'admin_page.dart';
import 'colors.dart';
import 'list_destination.dart';
import 'list_detail_page.dart';
import 'colors.dart';

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
