import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/addbutton.dart';
import 'package:flutter_application_10/pags/widget/editbutton.dart';
import 'package:flutter_application_10/pags/widget/hederbardashbord.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:flutter_application_10/shard/app_colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TableDepartmentdata extends StatefulWidget {
  const TableDepartmentdata({super.key});
  @override
  State<TableDepartmentdata> createState() => _TableCollagedataState();
}

class _TableCollagedataState extends State<TableDepartmentdata> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Container(
        height: 650,
        decoration: BoxDecoration(
          color: AppColors.bgcolor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
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
                      description: TextEditingController(),
                    );
                  }
                },
              ),
            ),
            Divider(thickness: 0.5, color: Colors.green),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.green, width: 0.5),
                    ),
                  ),
                  children: [
                    tableHedar('collage Name'),
                    // tableHedar('password_dean'),
                    tableHedar('Collage Dean'),
                    // tableHedar(''),
                  ],
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Colleges')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
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
          ],
        ),
      ),
    );
  }

  TableRow tabblRow(
    context, {
    name,
    image,
    description,
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
          Text('$description'),
          Row(
            children: [
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
                                  title: 'Add collage',
                                  controller: TextEditingController(),
                                  description: TextEditingController(),
                                );
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
            Text('نبذة: ${data['description'] ?? ''}'),
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

    TextEditingController nameController =
        TextEditingController(text: doc['name']);
    TextEditingController adminController =
        TextEditingController(text: doc['admin']);
    TextEditingController descriptionController =
        TextEditingController(text: doc['description'] ?? '');

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
            controller: descriptionController,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(labelText: 'نبذة تعريفية عن الكلية'),
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
                'description': descriptionController.text,
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









// class _TableCollagedataState extends State<TableDepartmentdata> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: 650,
//         decoration: BoxDecoration(
//             color: AppColors.bgcolor, borderRadius: BorderRadius.circular(20)),
//         padding: EdgeInsets.all(20),
//         child: Column(children: [
//           Hederbardashbord(
//             page_name: 'Department',
//             button: MyButton(
//                 color: Colors.blue,
//                 title: 'Add Department',
//                 onPressed: () {
//                   Addbutton.ShowCustomDilalog(
//                       context: context,
//                       title: "Add department",
//                       controller: TextEditingController(),
                
//                       );
//                 }),
//           ),
//           Divider(thickness: 0.5, color: Colors.green),
//           Table(
//               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//               children: [
//                 //HeaderTable
//                 TableRow(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(color: Colors.green, width: 0.5),
//                       ),
//                     ),
//                     children: [
//                       // tableHedar('Department'),
//                       tableHedar('Department Name'),
//                       tableHedar('Department Dean'),
//                       tableHedar('password Dean'),
//                       // tableHedar(''),
//                     ]),
//               ]),
//           //Data Table
//           Expanded(
//             child: SingleChildScrollView(
//               child: Table(
//                 defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                 children: [
//                   tabblRow(context,
//                       // department: 10,
//                       name: 'الطب',
//                       image: 'images/كلية الطب .png',
//                       dean: 'Dr.jamal AL Ameri',
//                       password: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       // department: 10,
//                       name: 'الهندسةوتقنيةالمعلومات',
//                       image: 'images/كلية العلوم الإدارية .png',
//                       dean: 'Ahmed'),
//                   tabblRow(context,
//                       name: 'العلوم التطبيقية',
//                       image: 'images/كلية العلوم التطبيقية .png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'العلوم الإدارية',
//                       image: 'images/managmentscinecie.png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'الحقوق',
//                       image: 'images/كلية الحقوق.png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'الأداب',
//                       image:
//                           'images/png-transparent-paper-ink-fountain-pen-ballpoint-pen-pen-and-ink-ink-textile-cosmetics-thumbnail.png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri',
//                       password: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'التربية',
//                       image: 'images/كلية التربية ٣.png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri',
//                       password: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'اللغات والترجمة',
//                       image: 'images/اللغات والترجمة .png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri',
//                       password: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'الحاسب الالي',
//                       image: 'images/الحاسب الآلي .png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri',
//                       password: 'Dr.jamal AL Ameri'),
//                   tabblRow(context,
//                       name: 'التعليم المستمر',
//                       image: 'images/كلية العلوم الإدارية .png',
//                       // department: 10,
//                       dean: 'Dr.jamal AL Ameri',
//                       password: 'Dr.jamal AL Ameri'),
//                 ],
//               ),
//             ),
//           )
//           //   ],
//           // )
//         ]),
//       ),
//     );
//   }

//   TableRow tabblRow(
//     context, {
//     name,
//     image,
//     department,
//     dean,
//     password,
//   }) {
//     return TableRow(
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: Colors.green, width: 0.5),
//           ),
//         ),
//         children: [
//           // Text('$department'),
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 15),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(1000),
//                   child: Image.asset(
//                     "$image",
//                     // height: 40,
//                     width: 60,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Text(name),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               // Container(
//               //     decoration: BoxDecoration(
//               //         shape: BoxShape.circle, color: AppColors.maincolor),
//               //     height: 10,
//               //     width: 10),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(dean),
//             ],
//           ),
//           Text('$password'),
//           Row(
//             children: [
//               IconButton(
//                   onPressed: () {
//                     Editbutton.showAlert(
//                         context: context,
//                         title: 'Edit',
//                         content: Text('Bilalaa dfhjgfsbvs hfhgfjgf ?'),
//                         action: [
//                           TextButton(
//                               onPressed: () {
//                                 Addbutton.ShowCustomDilalog(
//                                     context: context,
//                                     title: 'Edit collage or Admin',
//                                     controller: TextEditingController(),
//                                     // password: TextEditingController()
//                                     );
//                               },
//                               child: Text('oke')),
//                           TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('No'))
//                         ]);
//                   },
//                   icon: Icon(Icons.edit)),
//               Icon(Icons.more_vert),
//               IconButton(onPressed: () {}, icon: Icon(Icons.delete))
//             ],
//           )
//         ]);
//   }

//   Widget tableHedar(text) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 15),
//       child: Text(
//         text,
//         style: TextStyle(
//             color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
