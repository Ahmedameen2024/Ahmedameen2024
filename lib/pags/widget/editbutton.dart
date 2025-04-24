// import 'package:flutter/material.dart';

// class Editbutton {
//   static void showAlert({
//     required BuildContext context,
//     required String title,
//     required Widget content,
//     List<Widget>? action,
//     bool barrierDismissible = true,
//   }) {
//     showDialog(
//         context: context,
//         barrierDismissible: barrierDismissible,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               alignment: AlignmentDirectional.center,
//               titlePadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//               titleTextStyle: TextStyle(
//                   fontSize: 30,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold),
//               title: Text(title),
//               content: content,
//               actions: action ?? []);
//         });
//   }
// }

// في ملف Editbutton.dart
import 'package:flutter/material.dart';

class Editbutton {
  static void showAlert({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? action,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: AlignmentDirectional.center,
          titlePadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          titleTextStyle: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          title: Text(title),
          content: SingleChildScrollView(child: content),
          actions: action ?? [],
        );
      },
    );
  }
}
