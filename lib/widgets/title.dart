import 'package:flutter/material.dart';

class TitleHeading extends StatelessWidget {
  final String title;
  const TitleHeading({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 30, bottom: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
    );
  }
}
