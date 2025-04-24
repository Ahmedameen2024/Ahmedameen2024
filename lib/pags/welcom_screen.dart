import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/sin_in.dart';
import 'package:flutter_application_10/pags/sin_ub.dart';
import 'package:flutter_application_10/pags/my_botton.dart';

class WelcomScreen extends StatefulWidget {
  static const String welcomScreenRout = 'welcom_screen';
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset('images/كلية الطب .png'),
                ),
                const Text(
                  'Bilal',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              title: 'sinIn',
              onPressed: () {
                Navigator.pushNamed(context, SinIn.sinInScreenRout);
              },
            ),
            MyButton(
              color: Colors.blue[900]!,
              title: 'sinUp',
              onPressed: () {
                Navigator.pushNamed(context, SignUp.signUpScreenRoute);
              },
            )
          ],
        ),
      ),
    );
  }
}

// class Mybotton extends StatelessWidget {
//   final Color color;
//   final String titel;
//   final Function onpressd;

//   const Mybotton(
//       {super.key,
//       required this.color,
//       required this.titel,
//       required this.onpressd});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Material(
//         elevation: 5,
//         color: color,
//         borderRadius: BorderRadius.circular(10),
//         child: MaterialButton(
//           onPressed: () => onpressd,
//           minWidth: 200,
//           height: 42,
//           child: Text(titel),
//         ),
//       ),
//     );
//   }
// }
