// ignore: file_names
// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/addbutton.dart';
import 'package:flutter_application_10/pags/widget/editbutton.dart';
import 'package:flutter_application_10/pags/widget/hederbardashbord.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:flutter_application_10/shard/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart'; // أضف هذا الاستيراد

class TableCollagedata extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String TableCollagedataRout = 'TableCollagedata';
  const TableCollagedata({super.key});
  @override
  State<TableCollagedata> createState() => _TableCollagedataState();
}

class _TableCollagedataState extends State<TableCollagedata> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // scrollDirection: Axis.horizontal,
        height: 650,
        decoration: BoxDecoration(
            color: AppColors.bgcolor, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Hederbardashbord(
            page_name: 'Collage',
            button: MyButton(
              color: Colors.blue,
              title: 'Add Collage',
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يجب تسجيل الدخول أولاً'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  Addbutton.ShowCustomDilalog(
                    context: context,
                    title: 'Add collage',
                    controller: TextEditingController(),
                    admin: TextEditingController(),
                    password: TextEditingController(),
                  );
                }
              },
            ),

            // button: MyButton(
            //     color: Colors.blue,
            //     title: 'Add Collage',
            //     onPressed: () {
            //       Addbutton.ShowCustomDilalog(
            //           context: context,
            //           title: 'Add colage',
            //           controller: TextEditingController(),
            //           admin: TextEditingController(),
            //           password: TextEditingController()
            //           // action: []
            //           );
            //     }),
          ),
          Divider(thickness: 0.5, color: Colors.green),

          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              //HeaderTable
              TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.green, width: 0.5),
                    ),
                  ),
                  children: [
                    tableHedar('collage Name'),
                    tableHedar('password_dean'),
                    tableHedar('Collage Dean'),
                    tableHedar(''),
                  ]),
            ],
          ),

          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: _firestore.collection('Colleges').snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) {
          //         return const Center(child: Text('حدث خطأ في جلب البيانات'));
          //       }

          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }

          //       final docs = snapshot.data?.docs ?? [];
          //       if (docs.isEmpty) {
          //         return const Center(child: Text('لا توجد كليات متاحة'));
          //       }

          //       return ListView.builder(
          //         itemCount: docs.length,
          //         itemBuilder: (context, index) {
          //           final doc = docs[index];
          //           // DocumentSnapshot doc = snapshot.data!.docs[index];
          //           return _buildCollegeRow(doc);
          //         },
          //       );
          //     },
          //   ),
          // ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Colleges').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // return ListView.builder(
                //   // scrollDirection: Axis.horizontal,
                //   itemCount: snapshot.data!.docs.length,
                //   itemBuilder: (context, index) {
                //     DocumentSnapshot doc = snapshot.data!.docs[index];
                //     return _buildCollegeRow(doc);
                //   },
                // );

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];

                    // تحقق من وجود البيانات
                    if (!doc.exists) return SizedBox.shrink();

                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['name'] ?? 'No Name'),
                      subtitle: Text(data['admin']?.toString() ?? 'No Admin'),
                    );
                  },
                );
              },
            ),
          ),

          //Data Table
        ]),
      ),
    );
  }

  TableRow tabblRow(
    context, {
    name,
    image,
    password_dean,
    dean,
  }) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.green, width: 0.5),
          ),
        ),
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.asset(
                    "$image",
                    // height: 40,
                    width: 60,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(name),
              ],
            ),
          ),
          Text('$password_dean'),
          Row(
            children: [
              // Container(
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle, color: AppColors.maincolor),
              //     height: 10,
              //     width: 10),
              SizedBox(
                width: 10,
              ),
              Text(dean)
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Editbutton.showAlert(
                        context: context,
                        title: 'Edit',
                        content: Text('Bilalaa dfhjgfsbvs hfhgfjgf ?'),
                        action: [
                          TextButton(
                              onPressed: () {
                                Addbutton.ShowCustomDilalog(
                                    context: context,
                                    title: 'Edit collage or Admin',
                                    controller: TextEditingController(),
                                    admin: TextEditingController(),
                                    password: TextEditingController());
                              },
                              child: Text('oke')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'))
                        ]);
                  },
                  icon: Icon(Icons.edit)),
              Icon(Icons.more_vert),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete))
            ],
          )
        ]);
  }

  Widget tableHedar(text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget alertButton({title, p, f, g}) {
  //   return ListTile(
  //     title: Text(title),
  //     onTap: () {
  //       Editbutton.showAlert(
  //         context: context,
  //         title: title,
  //         content: Column(
  //           children: [
  //             Text('Bilalaa dfhjgfsbvs hfhgfjgf $title?'),
  //             Row(
  //               children: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Addbutton.ShowCustomDilalog(
  //                         context: context,
  //                         title: 'Edit $title',
  //                         controller:f,
  //                         admin: p,
  //                         password: g);
  //                   },
  //                   child: Text('Oke'),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {},
  //                   child: Text('No'),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildCollegeRow(DocumentSnapshot doc) {
    if (!doc.exists) return SizedBox.shrink();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(data['name'][0]),
        ),
        title: Text(data['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المشرف: ${data['admin']}'),
            Text('كلمة المرور: ${data['password']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(doc),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteCollege(doc.id),
            ),
          ],
        ),
      ),
    );
  }

//   Widget _buildCollegeRow(DocumentSnapshot doc) {
//   // تحقق من وجود البيانات أولاً
//   if (!doc.exists) return SizedBox.shrink();

//   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//   return ListTile(
//     title: Text(data['name'] ?? 'No Name'), // استخدام قيمة افتراضية
//     subtitle: Text(data['admin']?.toString() ?? 'No Admin'),
//   );
// }

  // void _showEditDialog(DocumentSnapshot doc) {
  //   // Implement edit functionality similar to add

  //   TextEditingController nameController =
  //       TextEditingController(text: doc['name']);
  //   TextEditingController adminController =
  //       TextEditingController(text: doc['admin']);
  //   TextEditingController passwordController =
  //       TextEditingController(text: doc['password']);

  //   Editbutton.showAlert(
  //     context: context,
  //     title: 'تعديل الكلية',
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         TextFormField(
  //           controller: nameController,
  //           decoration: InputDecoration(labelText: 'اسم الكلية'),
  //         ),
  //         TextFormField(
  //           controller: adminController,
  //           decoration: InputDecoration(labelText: 'اسم المشرف'),
  //         ),
  //         TextFormField(
  //           controller: passwordController,
  //           obscureText: true,
  //           decoration: InputDecoration(labelText: 'كلمة المرور'),
  //         ),
  //       ],
  //     ),
  //     action: [
  //       TextButton(
  //         child: Text('حفظ'),
  //         onPressed: () async {
  //           try {
  //             await _firestore.collection('Colleges').doc(doc.id).update({
  //               'name': nameController.text,
  //               'admin': adminController.text,
  //               'password': passwordController.text,
  //             });
  //             Navigator.of(context).pop();
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text('تم التحديث بنجاح')),
  //             );
  //           } catch (e) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text('خطأ في التحديث: $e')),
  //             );
  //           }
  //         },
  //       ),
  //       TextButton(
  //         child: Text('إلغاء'),
  //         onPressed: () => Navigator.of(context).pop(),
  //       ),
  //     ],
  //   );
  // }

  void _showEditDialog(DocumentSnapshot doc) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تسجيل الدخول أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // ... باقي الكود

    TextEditingController nameController =
        TextEditingController(text: doc['name']);
    TextEditingController adminController =
        TextEditingController(text: doc['admin']);
    TextEditingController passwordController =
        TextEditingController(text: doc['password']);

    Editbutton.showAlert(
      context: context,
      title: 'تعديل الكلية',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'اسم الكلية'),
          ),
          TextFormField(
            controller: adminController,
            decoration: InputDecoration(labelText: 'اسم المشرف'),
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'كلمة المرور'),
          ),
        ],
      ),
      action: [
        TextButton(
          child: Text('حفظ'),
          onPressed: () async {
            try {
              await _firestore.collection('Colleges').doc(doc.id).update({
                'name': nameController.text,
                'admin': adminController.text,
                'password': passwordController.text,
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم التحديث بنجاح')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطأ في التحديث: $e')),
              );
            }
          },
        ),
        TextButton(
          child: Text('إلغاء'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  // Future<void> _deleteCollege(String docId) async {

  // }

  Future<void> _deleteCollege(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تسجيل الدخول أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // ... باقي الكود
    try {
      await _firestore.collection('Colleges').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الحذف بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الحذف: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}



























// import 'package:flutter/material.dart';
// import 'package:flutter_application_10/pags/widget/addbutton.dart';
// import 'package:flutter_application_10/shard/app_colors.dart';


// class TableCollagedata extends StatefulWidget {
//   const TableCollagedata({super.key});

//   @override
//   State<TableCollagedata> createState() => _TableCollagedataState();
// }

// class _TableCollagedataState extends State<TableCollagedata> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.bgcolor,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // ... (Header part remains the same)

//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore.collection('Colleges').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Center(child: Text('حدث خطأ في جلب البيانات'));
//                   }

//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot doc = snapshot.data!.docs[index];
//                       return _buildCollegeRow(doc);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCollegeRow(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.blueAccent,
//           child: Text(data['name'][0]),
//         ),
//         title: Text(data['name']),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('المشرف: ${data['admin']}'),
//             // Text('كلمة المرور: ${data['password']}'),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () => _showEditDialog(doc),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _deleteCollege(doc.id),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditDialog(DocumentSnapshot doc) {
//     // Implement edit functionality similar to add

//     TextEditingController nameController =
//         TextEditingController(text: doc['name']);
//     TextEditingController adminController =
//         TextEditingController(text: doc['admin']);
//     // TextEditingController passwordController =
//     //     TextEditingController(text: doc['password']);

//     Editbutton.showAlert(
//       context: context,
//       title: 'تعديل الكلية',
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextFormField(
//             controller: nameController,
//             decoration: InputDecoration(labelText: 'اسم الكلية'),
//           ),
//           TextFormField(
//             controller: adminController,
//             decoration: InputDecoration(labelText: 'اسم المشرف'),
//           ),
//           TextFormField(
//             // controller: passwordController,
//             obscureText: true,
//             decoration: InputDecoration(labelText: 'كلمة المرور'),
//           ),
//         ],
//       ),
//       action: [
//         TextButton(
//           child: Text('حفظ'),
//           onPressed: () async {
//             try {
//               await _firestore.collection('Colleges').doc(doc.id).update({
//                 'name': nameController.text,
//                 'admin': adminController.text,
//                 // 'password': passwordController.text,
//               });
//               Navigator.of(context).pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('تم التحديث بنجاح')),
//               );
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('خطأ في التحديث: $e')),
//               );
//             }
//           },
//         ),
//         TextButton(
//           child: Text('إلغاء'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }

//   Future<void> _deleteCollege(String docId) async {
//     try {
//       await _firestore.collection('Colleges').doc(docId).delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('تم الحذف بنجاح'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('خطأ في الحذف: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // في ملف TableCollagedata.dart
//   // void _showEditDialog(DocumentSnapshot doc) {

//   // }
// }











