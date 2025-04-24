import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/pags/widget/chat_screen.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:flutter_application_10/pags/VerificationScreen.dart';

class SignUp extends StatefulWidget {
  static const String signUpScreenRoute = 'SignUp';
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String userName = '';
  String email = '';
  String password = '';
  bool mounted = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 100,
              child: Image.asset('images/كلية الطب .png'),
            ),
            const SizedBox(height: 50),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (val) => userName = val,
              decoration: InputDecoration(
                hintText: 'User name',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (val) => email = val,
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (val) => password = val,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MyButton(
              color: Colors.blue[800]!,
              title: 'Register',
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  if (userName.isEmpty || email.isEmpty || password.isEmpty) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                    return;
                  }

                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (userCredential.user == null) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User creation failed')),
                      );
                    }
                    return;
                  }

                  await _firestore
                      .collection('Users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'uid': userCredential.user!.uid,
                    'userName': userName,
                    'email': email,
                    'password': password,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  await userCredential.user!.sendEmailVerification();

                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  }
                } on FirebaseAuthException catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    String errorMessage = 'Registration failed';
                    switch (e.code) {
                      case 'weak-password':
                        errorMessage = 'Password must be at least 6 characters';
                        break;
                      case 'email-already-in-use':
                        errorMessage = 'Email already registered';
                        break;
                      case 'invalid-email':
                        errorMessage = 'Invalid email address';
                        break;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

















// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // <-- إضافة هذه المكتبة
// import 'package:flutter_application_10/pags/my_botton.dart';
// // ignore: duplicate_import
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// // ignore: unused_import

// import 'firebase_options.dart';
// // // ignore: unused_import

// class SignUp extends StatefulWidget { // <-- تصحيح اسم الكلاس
//   static const String signUpScreenRoute = 'SignUp';
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   String userName = '';
//   String email = '';
//   String password = '';

//   // إضافة مرجع Firestore هنا
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//            MyButton(
//               title: 'Register',
//               onPressed: () async {
//                 try {
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (context) => const Center(child: CircularProgressIndicator()),
//                   );

//                   if (userName.isEmpty || email.isEmpty || password.isEmpty) {
//                     throw 'Please fill all fields';
//                   }

//                   final userCredential = await FirebaseAuth.instance
//                       .createUserWithEmailAndPassword(
//                         email: email,
//                         password: password,
//                       );

//                   if (userCredential.user == null) {
//                     throw 'User creation failed';
//                   }

//                   // استخدام _firestore هنا بعد تعريفه
//                   await _firestore.collection('Users').doc(userCredential.user!.uid).set({
//                     'uid': userCredential.user!.uid,
//                     'userName': userName,
//                     'email': email,
//                     'createdAt': FieldValue.serverTimestamp(),
//                   });

//                   await userCredential.user!.sendEmailVerification();

//                   if (!mounted) return;
//                   Navigator.pop(context);
//                   Navigator.pushReplacementNamed(context, 'HomeScreen');

//                 } on FirebaseAuthException catch (e) {
//                   if (mounted) Navigator.pop(context);
//                   String errorMessage = 'Registration failed';
//                   switch (e.code) {
//                     case 'weak-password':
//                       errorMessage = 'Password is too weak';
//                       break;
//                     case 'email-already-in-use':
//                       errorMessage = 'Email already exists';
//                       break;
//                     case 'invalid-email':
//                       errorMessage = 'Invalid email format';
//                       break;
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(errorMessage)),
//                   );
//                 } catch (e) {
//                   if (mounted) {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(e.toString())),
//                     );
//                   }
//                 }
//               },
//                color: Colors.blue[800]!,
//             ),
//             // ignore: unused_import
//             const SizedBox(height: 10)
//           ],
//         ),
//       ),
//     );
//   }
// }