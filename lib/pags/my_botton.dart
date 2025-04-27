import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed; // Required callback

  // ignore: use_super_parameters, prefer_const_constructors_in_immutables
  const MyButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onPressed,
    //     required Future<Null> Function() onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(title),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   child: Material(
    //     elevation: 5,
    //     color: color,
    //     borderRadius: BorderRadius.circular(10),
    //     child: MaterialButton(
    //       onPressed: onPressed,
    //       minWidth: 200,
    //       height: 42,
    //       child: Text(
    //         title,
    //         style: const TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   ),
    // );
  }
}

// class MyButton extends StatelessWidget {
//   final String title;
//   final Color color;
//   final VoidCallback onPressed; // Required callback

//   // ignore: use_super_parameters, prefer_const_constructors_in_immutables
//   const MyButton({
//     Key? key,
//     required this.title,
//     required this.color,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(backgroundColor: color),
//       onPressed: onPressed,
//       child: Text(title),
//     );
//   }
// }
