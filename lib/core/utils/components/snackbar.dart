import 'package:flutter/material.dart';

void snackBarMessage({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Durations.extralong1,
    ),
  );
}

// void s(context,message){
//
//   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//     content: Text('Registered Successfully'),
//     backgroundColor: Colors.green,
//   ));
// }
