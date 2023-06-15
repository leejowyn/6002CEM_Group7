import 'package:flutter/material.dart';

class AlertDialogError extends StatelessWidget {
  final String errDesc;
  const AlertDialogError({Key? key, required this.errDesc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Oops, something went wrong!'),
      icon: Icon(
        Icons.error,
        color: Colors.red.shade300,
        size: 80,
      ),
      content: Text(
        errDesc,
      ),
      contentPadding:
      EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}