// ignore_for_file: use_build_context_synchronously, unused_field, unused_element, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/pags/widget/table_Collagedata.dart';

import 'package:flutter_application_10/pags/VerificationScreen.dart';

class SinIn extends StatefulWidget {
  static const String sinInScreenRout = 'SinIn';
  const SinIn({super.key});

  @override
  State<SinIn> createState() => _SinInState();
}

class _SinInState extends State<SinIn> {
  String email = '';
  String password = '';

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
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (val) => email = val,
              decoration: const InputDecoration(
                hintText: 'Enter your Email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (val) => password = val,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            MyButton(
              // color: Colors.yellow[800]!,
              title: 'Sign In',
              color: Colors.blue,
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);

                  if (userCredential.user!.emailVerified) {
                    // لا حاجة لأي توجيه هنا، الـ StreamBuilder سيتولى الأمر
                  } else {
                    await userCredential.user!.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إرسال رابط التحقق')),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  String errorMessage = 'حدث خطأ، الرجاء المحاولة مرة أخرى';
                  switch (e.code) {
                    case 'user-not-found':
                      errorMessage = 'البريد الإلكتروني غير مسجل';
                      break;
                    case 'wrong-password':
                      errorMessage = 'كلمة المرور غير صحيحة';
                      break;
                    case 'invalid-email':
                      errorMessage = 'بريد إلكتروني غير صالح';
                      break;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter_application_10/pags/TableCollagedata.dart'; // تأكد من صحة المسار








// class SinIn extends StatefulWidget {
//   static const String sinInScreenRout = 'SinIn';
//   const SinIn({super.key});

//   @override
//   State<SinIn> createState() => _SinInState();
// }

// class _SinInState extends State<SinIn> {
//   bool _isLoading = false;
//   String email = '';
//   String password = '';
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   Future<void> _signIn(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (userCredential.user != null) {
//         Navigator.pushReplacementNamed(
//           context,
//           TableCollagedata.TableCollagedataRout,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       _handleAuthError(e, context);
//     } finally {
//       if (mounted) {
//         // <-- التحقق من وجود الصفحة
//         setState(() => _isLoading = false); // إيقاف التحميل
//       }
//     }
//   }

//   void _handleAuthError(FirebaseAuthException e, BuildContext context) {
//     String errorMessage = 'حدث خطأ أثناء التسجيل';

//     switch (e.code) {
//       case 'user-not-found':
//         errorMessage = 'البريد الإلكتروني غير مسجل';
//         break;
//       case 'wrong-password':
//         errorMessage = 'كلمة المرور غير صحيحة';
//         break;
//       case 'invalid-email':
//         errorMessage = 'صيغة البريد الإلكتروني غير صالحة';
//         break;
//       case 'user-disabled':
//         errorMessage = 'الحساب معطل';
//         break;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(errorMessage)),
//     );
//   }

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
//             SizedBox(
//               height: 100,
//               child: Image.asset('images/كلية الطب .png'),
//             ),
//             const SizedBox(height: 50),
//             TextField(
//               keyboardType: TextInputType.emailAddress,
//               textAlign: TextAlign.center,
//               onChanged: (val) => email = val,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your Email',
//                 contentPadding:
//                     EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.orange, width: 1),
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue, width: 2),
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               obscureText: true,
//               textAlign: TextAlign.center,
//               onChanged: (val) => password = val,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your password',
//                 contentPadding:
//                     EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.orange, width: 1),
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue, width: 2),
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             MyButton(
//               // color: Colors.yellow[800]!,
//               title: 'Sign In',
//               color: Colors.blue,
//               onPressed: () async {
//                 try {
//                   UserCredential userCredential = await FirebaseAuth.instance
//                       .signInWithEmailAndPassword(
//                           email: email, password: password);
//                   if (userCredential.user!.emailVerified) {
//                     // لا حاجة لأي توجيه هنا، الـ StreamBuilder سيتولى الأمر
//                   } else {
//                     await userCredential.user!.sendEmailVerification();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('تم إرسال رابط التحقق')),
//                     );
//                   }
//                 } on FirebaseAuthException catch (e) {
//                   String errorMessage = 'حدث خطأ، الرجاء المحاولة مرة أخرى';
//                   switch (e.code) {
//                     case 'user-not-found':
//                       errorMessage = 'البريد الإلكتروني غير مسجل';
//                       break;
//                     case 'wrong-password':
//                       errorMessage = 'كلمة المرور غير صحيحة';
//                       break;
//                     case 'invalid-email':
//                       errorMessage = 'بريد إلكتروني غير صالح';
//                       break;
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(errorMessage)),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:cloud_firestore/cloud_firestore.dart';
// Future<List<Map<String, dynamic>>> getGraduatesData() async {
//   List<Map<String, dynamic>> graduatesList = [];

//   try {
//     // جلب جميع وثائق الخريجين
//     QuerySnapshot graduatesSnapshot =
//         await FirebaseFirestore.instance.collection('graduates').get();

//     for (var gradDoc in graduatesSnapshot.docs) {
//       // بيانات الخريج الأساسية
//       Map<String, dynamic> graduateData =
//           gradDoc.data() as Map<String, dynamic>;

//       // جلب بيانات المستخدم (الاسم)
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(gradDoc['userId'])
//           .get();
//       Map<String, dynamic> userData =
//           userSnapshot.data() as Map<String, dynamic>;

//       // جلب بيانات القسم
//       DocumentSnapshot departmentSnapshot = await FirebaseFirestore.instance
//           .collection('departments')
//           .doc(gradDoc['departmentId'])
//           .get();
//       Map<String, dynamic> departmentData =
//           departmentSnapshot.data() as Map<String, dynamic>;

//       // جلب بيانات الكلية
//       DocumentSnapshot collegeSnapshot = await FirebaseFirestore.instance
//           .collection('colleges')
//           .doc(gradDoc['collegeId'])
//           .get();
//       Map<String, dynamic> collegeData =
//           collegeSnapshot.data() as Map<String, dynamic>;

//       // تجميع البيانات
//       graduatesList.add({
//         'name': userData['name'],
//         'department': departmentData['name'],
//         'college': collegeData['name'],
//         'year': graduateData['graduationYear'],
//       });
//     }
//   } catch (e) {
//     print("Error fetching data: $e");
//   }

//   return graduatesList;
// }
