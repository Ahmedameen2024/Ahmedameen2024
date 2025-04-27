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

  List<Map<String, dynamic>> usersList = [];
  bool usersLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final usersSnapshot = await _firestore.collection('Users').get();
    setState(() {
      usersList = usersSnapshot.docs
          .map((doc) => {
                'uid': doc['uid'],
                'userName': doc['userName'],
              })
          .toList();
      usersLoaded = true;
    });
  }

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
                    tableHedar('description'),
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
                      return _buildCollegeRow(
                          doc); // استخدم الدالة المخصصة للعرض
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

    // ابحث عن اسم المدير بناءً على id_admin
    String? adminName;
    if (usersLoaded) {
      final user = usersList.firstWhere(
        (u) => u['uid'] == data['id_admin'],
        orElse: () => {},
      );
      adminName = user.isNotEmpty ? user['userName'] : data['id_admin'];
    } else {
      adminName = data['id_admin'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(data['name']?[0] ?? '?'),
        ),
        title: Text(data['name'] ?? 'No Name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المشرف: ${adminName ?? 'لا يوجد'}'),
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
        TextEditingController(text: doc['id_admin']);
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
                'id_admin': adminController.text,
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
