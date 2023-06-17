import 'package:flutter/material.dart';
import 'package:trip_planner/model/category_model.dart';

List<CategoryModel> categoryList = [
  CategoryModel(
    categoryName: "Natural",
    iconData: Icons.landscape
  ),
  CategoryModel(
    categoryName: "Cultural",
    iconData: Icons.temple_buddhist
  ),
  CategoryModel(
      categoryName: "Food and Drink",
      iconData: Icons.fastfood),
  CategoryModel(
      categoryName: "Shopping",
      iconData: Icons.shopping_bag),
  CategoryModel(
    categoryName: "Entertainment",
    iconData: Icons.celebration,
  ),
  CategoryModel(
    categoryName: "Accommodation",
    iconData: Icons.hotel,
  ),
  CategoryModel(
    categoryName: "Wellness and Spa",
    iconData: Icons.spa,
  )
];
