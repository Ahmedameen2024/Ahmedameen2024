// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // أضف هذا الاستيراد

// import 'package:flutter/material.dart';

// import 'package:flutter_application_10/pags/my_botton.dart';

class Addbutton {
  // ignore: non_constant_identifier_names
  static void ShowCustomDilalog({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required TextEditingController admin,
    required TextEditingController password,
  }) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    void _saveData() async {
      try {
        await _firestore.collection('Colleges').add({
          'name': controller.text,
          'admin': admin.text,
          'password': password.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الحفظ بنجاح في Firebase'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الحفظ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        titlePadding: const EdgeInsets.symmetric(horizontal: 30),
        content: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Name collage',
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
            const SizedBox(height: 5),
            TextFormField(
              controller: admin,
              decoration: const InputDecoration(
                labelText: 'Admin Name',
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
            const SizedBox(height: 5),
            TextFormField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Admin Password',
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
          ],
        ),
        actions: [
          Row(
            children: [
              MyButton(
                  color: Colors.blue,
                  title: 'Save',
                  onPressed: _saveData // التعديل الرئيسي هنا
                  ),
              const Spacer(),
              MyButton(
                  color: Colors.blue,
                  title: 'cansal',
                  onPressed: () => Navigator.pop(context))
            ],
          )
        ],
      ),
    );
  }

  Widget nputfiled({nput}) {
    return Expanded(
      child: Container(
        child: TextFormField(
          controller: nput,
          decoration: const InputDecoration(
            labelText: 'Name collage',
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_10/pags/my_botton.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Addbutton {
//   static void ShowCustomDilalog({
//     required BuildContext context,
//     required String title,
//     required TextEditingController controller,
//     required TextEditingController admin,
//     required TextEditingController password,
//   }) {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     final FirebaseAuth _auth = FirebaseAuth.instance;

//     void _saveData() async {
//       final User? user = _auth.currentUser;

//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('يجب تسجيل الدخول أولاً'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       try {
//         await _firestore.collection('Colleges').add({
//           'name': controller.text,
//           'admin': admin.text,
//           'password': password.text,
//           'createdBy': user.uid, // إضافة معرف المستخدم
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('تمت إضافة الكلية بنجاح'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('خطأ في الإضافة: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       // ... باقي الكود بدون تغيير
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(title),
//           titlePadding: const EdgeInsets.symmetric(horizontal: 30),
//           content: Column(
//             children: [
//               TextFormField(
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   labelText: 'Name collage',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.orange, width: 1),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: admin,
//                 decoration: const InputDecoration(
//                   labelText: 'Admin Name',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.orange, width: 1),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: password,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Admin Password',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.orange, width: 1),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             Row(
//               children: [
//                 MyButton(
//                     color: Colors.blue,
//                     title: 'Save',
//                     onPressed: _saveData // التعديل الرئيسي هنا
//                     ),
//                 const Spacer(),
//                 MyButton(
//                     color: Colors.blue,
//                     title: 'cansal',
//                     onPressed: () => Navigator.pop(context))
//               ],
//             )
//           ],
//         ),
//       );
//     }

//     Widget nputfiled({nput}) {
//       return Expanded(
//         child: Container(
//           child: TextFormField(
//             controller: nput,
//             decoration: const InputDecoration(
//               labelText: 'Name collage',
//               contentPadding:
//                   EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.orange, width: 1),
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.blue, width: 2),
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }





// class Addbutton {
//   static void ShowCustomDilalog({
//     required BuildContext context,
//     required String title,
//     // required Widget content,
//     required TextEditingController controller,
//     required TextEditingController admin,
//     required TextEditingController password,
//     // required List<Widget> action,
//   }) {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text(title),
//               titlePadding: EdgeInsets.symmetric(horizontal: 30),
//               content: Column(
//                 children: [
//                   TextFormField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       labelText: 'Name collage',
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.orange, width: 1),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blue, width: 2),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextFormField(
//                     controller: admin,
//                     decoration: InputDecoration(
//                       labelText: 'Admin Name',
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.orange, width: 1),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blue, width: 2),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextFormField(
//                     controller: password,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Admin Password',
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.orange, width: 1),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blue, width: 2),
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 Row(
//                   children: [
//                     MyButton(
//                         color: Colors.blue,
//                         title: 'Save',
//                         onPressed: () {
//                           print(controller.value.text);
//                           print(admin.value.text);
//                           print(password.value.text);
//                         }),
//                     Spacer(),
//                     MyButton(
//                         color: Colors.blue, title: 'cansal', onPressed: () {})
//                   ],
//                 )
//               ],
//             ));
//   }

//   static void _showSuccessSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('تمت إضافة الكلية بنجاح'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   static void _showErrorSnackbar(BuildContext context, String error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('خطأ في الإضافة: $error'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Widget nputfiled({nput}) {
//     return Expanded(
//       child: Container(
//         child: TextFormField(
//           controller: nput,
//           decoration: InputDecoration(
//             labelText: 'Name collage',
//             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.orange, width: 1),
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.blue, width: 2),
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_10/pags/my_botton.dart';

// class Addbutton {
//   static void showCustomDialog({
//     required BuildContext context,
//     required String title,
//     required TextEditingController controller,
//     required TextEditingController admin,
//     required TextEditingController password,
//     // required List<Widget> action,
//   }) {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildTextFormField(
//               controller: controller,
//               label: 'College Name',
//             ),
//             const SizedBox(height: 10),
//             _buildTextFormField(
//               controller: admin,
//               label: 'Admin Name',
//             ),
//             const SizedBox(height: 10),
//             _buildTextFormField(
//               controller: password,
//               label: 'Admin Password',
//               isPassword: true,
//             ),
//           ],
//         ),
//         actions: [
//           Row(
//             children: [
//               MyButton(
//                 color: Colors.blue,
//                 title: 'Save',
//                 onPressed: () async {
//                   try {
//                     await _firestore.collection('Colleges').add({
//                       'name': controller.text.trim(),
//                       'admin': admin.text.trim(),
//                       'password': password.text.trim(),
//                       'timestamp': FieldValue.serverTimestamp(),
//                     });
//                     Navigator.pop(context);
//                     _showSuccessSnackbar(context);
//                   } catch (e) {
//                     _showErrorSnackbar(context, e.toString());
//                   }
//                 },
//               ),
//               const Spacer(),
//               MyButton(
//                 color: Colors.grey,
//                 title: 'Cancel',
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   static Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     bool isPassword = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//     );
//   }

//   static void _showSuccessSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('تمت إضافة الكلية بنجاح'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   static void _showErrorSnackbar(BuildContext context, String error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('خطأ في الإضافة: $error'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }