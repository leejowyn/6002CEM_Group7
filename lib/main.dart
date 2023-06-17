import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/admin_pages/admin_login.dart';
import 'package:trip_planner/admin_pages/admin_profile.dart';
import 'package:trip_planner/auth_page.dart';
import 'package:trip_planner/user_pages/destination_detail.dart';
import 'package:trip_planner/user_pages/destination_listing.dart';
import 'package:trip_planner/user_pages/explore.dart';
import 'package:trip_planner/user_pages/home.dart';
import 'package:trip_planner/user_pages/my_trip_listing.dart';
import 'package:trip_planner/user_pages/trip_form.dart';
import 'package:trip_planner/user_pages/trip_itinerary.dart';
import 'package:trip_planner/user_pages/user_login.dart';
import 'package:trip_planner/user_pages/navigation_page.dart';
import 'package:trip_planner/user_pages/user_profile.dart';
import 'package:trip_planner/user_pages/user_register.dart';
import 'package:trip_planner/splash_page.dart';
import 'package:trip_planner/view_model/destination_view_model.dart';
import 'package:trip_planner/view_model/timezone_view_model.dart';
import 'package:trip_planner/view_model/weather_view_model.dart';
import 'admin_pages/add_destination.dart';
import 'package:trip_planner/admin_pages/admin_page.dart';
import 'admin_pages/list_destination.dart';
import 'package:trip_planner/admin_pages/list_detail_page.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DestinationViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => TimezoneViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF0F3C4D),
          useMaterial3: true,
        ),
        initialRoute: AuthPage.routeName,
        routes: {
          AuthPage.routeName: (context) => const AuthPage(),
          SplashPage.routeName: (context) => const SplashPage(),
          // User
          UserRegisterPage.routeName: (context) => const UserRegisterPage(),
          UserLoginPage.routeName: (context) => UserLoginPage(),
          NavigationPage.routeName: (context) => const NavigationPage(),
          Home.routeName: (context) => const Home(),
          Explore.routeName: (context) => const Explore(),
          DestinationListing.routeName: (context) => const DestinationListing(),
          DestinationDetail.routeName: (context) => DestinationDetail(
              destinationId:
                  ModalRoute.of(context)?.settings.arguments as String),
          MyTripListing.routeName: (context) => const MyTripListing(),
          TripItinerary.routeName: (context) => const TripItinerary(),
          TripForm.routeName: (context) => const TripForm(),
          UserProfilePage.routeName: (context) => const UserProfilePage(),
          // Admin
          AdminLoginPage.routeName: (context) => AdminLoginPage(),
          AdminPage.routeName: (context) => const AdminPage(),
          ListDestination.routeName: (context) => const ListDestination(),
          ListDetailPage.routeName: (context) => const ListDetailPage(),
          AddDestination.routeName: (context) => const AddDestination(),
          AdminProfilePage.routeName: (context) => const AdminProfilePage(),
        },
      ),
    );
  }
}
