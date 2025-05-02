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
import 'package:firebase_storage/firebase_storage.dart';

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
                    // احذف عمود المدير
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
                      return _buildCollegeRow(doc);
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

    return _ExpandableCollegeRow(
      data: data,
      doc: doc,
      onEdit: _showEditDialog,
      onDelete: _deleteCollege,
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

class _ExpandableCollegeRow extends StatefulWidget {
  final Map<String, dynamic> data;
  final DocumentSnapshot doc;
  final Function(DocumentSnapshot) onEdit;
  final Function(String) onDelete;

  const _ExpandableCollegeRow({
    required this.data,
    required this.doc,
    required this.onEdit,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<_ExpandableCollegeRow> createState() => _ExpandableCollegeRowState();
}

class _ExpandableCollegeRowState extends State<_ExpandableCollegeRow>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String description = widget.data['description'] ?? '';
    final lines = description.split('\n');
    final bool needsReadMore = lines.length > 5;
    final String shortDescription =
        needsReadMore ? lines.take(5).join('\n') : description;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1.2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الكلية
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: widget.data['imageUrl'] != null &&
                      widget.data['imageUrl'].toString().isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.data['imageUrl']),
                      radius: 28,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(widget.data['name']?[0] ?? '?'),
                      radius: 28,
                    ),
            ),
            // بيانات الكلية (اسم + نبذة)
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['name'] ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue.shade50.withOpacity(0.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExpanded ? description : shortDescription,
                            maxLines: isExpanded ? null : 5,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                          if (needsReadMore)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                child:
                                    Text(isExpanded ? 'إخفاء' : 'قراءة المزيد'),
                                onPressed: () =>
                                    setState(() => isExpanded = !isExpanded),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // أزرار التعديل والحذف (ثابتة)
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 8, left: 8),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => widget.onEdit(widget.doc),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onDelete(widget.doc.id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
