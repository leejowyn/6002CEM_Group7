import 'package:flutter/material.dart';
import 'package:trip_planner/model/category_model.dart';
import 'package:trip_planner/user_pages/destination_listing.dart';

class CategoryImageWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryImageWidget({Key? key, required this.categoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          DestinationListing.routeName,
          arguments: categoryModel.categoryName,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20,
                spreadRadius: -10,
                offset: Offset(5, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  "images/${categoryModel.categoryName.toLowerCase().replaceAll(' ', '_')}.jpg",
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 150,
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black12, Colors.black]),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      categoryModel.categoryName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
