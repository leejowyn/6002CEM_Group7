import 'package:flutter/material.dart';
import 'package:trip_planner/data/category_list_data.dart';
import 'package:trip_planner/model/category_model.dart';

class CategoryViewModel extends ChangeNotifier {

  IconData getIconByCategory(String category) {
    CategoryModel? categoryModel = categoryList.firstWhere(
      (model) => model.categoryName == category,
      orElse: () =>
          CategoryModel(categoryName: '', iconData: Icons.location_pin),
    );

    return categoryModel.iconData;
  }

}
