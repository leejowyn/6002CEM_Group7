import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/colors.dart';
import 'package:trip_planner/data/category_list_data.dart';
import 'package:trip_planner/user_pages/destination_listing.dart';
import 'package:trip_planner/user_pages/user_profile.dart';
import 'package:trip_planner/widgets/category_image_widget.dart';
import 'package:trip_planner/widgets/title.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String routeName = '/homePage';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          const TitleHeading(title: "Categories"),
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                categoryList.length,
                (index) => CategoryImageWidget(
                  categoryModel: categoryList[index],
                ),
              ),
            ),
          ),
          const Flexible(child: DestinationListing()),
        ],
      ),
    );
  }
}
