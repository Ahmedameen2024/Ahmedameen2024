import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // أضف هذا الاستيراد
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addbuttonDepartments {
  static void ShowCustomDilalog({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    TextEditingController? description, // ← إضافة الحقل الجديد
  }) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final TextEditingController descriptionController = TextEditingController();
    File? _pickedImage;
    Uint8List? _webImageBytes; // متغير للويب
    String? selectedCollegeId; // متغير لتخزين id الكلية المختارة

    Future<void> _pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          _webImageBytes = await pickedFile.readAsBytes();
        } else {
          _pickedImage = File(pickedFile.path);
        }
      }
    }

    void _saveData() async {
      try {
        print('بدأ الحفظ');
        if (selectedCollegeId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى اختيار الكلية')),
          );
          return;
        }
        String? imageUrl;

        if (!kIsWeb && _pickedImage != null) {
          print('رفع صورة للهاتف...');
          final ref = FirebaseStorage.instance
              .ref()
              .child('Departments_images')
              .child('${DateTime.now().millisecondsSinceEpoch}.png');
          await ref.putFile(_pickedImage!);
          imageUrl = await ref.getDownloadURL();
          print('تم رفع الصورة للهاتف');
        } else if (kIsWeb && _webImageBytes != null) {
          print('رفع صورة للويب...');
          final ref = FirebaseStorage.instance
              .ref()
              .child('Departments_images')
              .child('${DateTime.now().millisecondsSinceEpoch}.png');
          await ref.putData(_webImageBytes!);
          imageUrl = await ref.getDownloadURL();
          print('تم رفع الصورة للويب');
        }

        print('سيتم حفظ بيانات القسم');
        await _firestore.collection('Departments').add({
          'name': controller.text,
          'description': descriptionController.text,
          'imageUrl': imageUrl ?? '',
          'collegeId': selectedCollegeId, // إضافة id الكلية
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('تم الحفظ بنجاح');
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الحفظ بنجاح في Firebase'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Firestore error: $e');
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(title),
            titlePadding: const EdgeInsets.symmetric(horizontal: 30),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'اسم القسم',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'نبذة تعريفية عن القسم',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // اختيار الكلية
                  const Text('اختر الكلية:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('Colleges').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) return const Text('لا توجد كليات');
                      return Column(
                        children: docs.map((doc) {
                          return RadioListTile<String>(
                            title: Text(doc['name']),
                            value: doc.id,
                            groupValue: selectedCollegeId,
                            onChanged: (val) =>
                                setState(() => selectedCollegeId = val),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // زر اختيار الصورة
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('اختيار صورة من المعرض'),
                    onPressed: () async {
                      await _pickImage();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  // عرض الصورة إذا تم اختيارها
                  if (kIsWeb)
                    _webImageBytes == null
                        ? Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 40),
                          )
                        : Image.memory(
                            _webImageBytes!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )
                  else
                    _pickedImage == null
                        ? Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 40),
                          )
                        : Image.file(
                            _pickedImage!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  MyButton(
                    color: Colors.blue,
                    title: 'حفظ',
                    onPressed: _saveData,
                  ),
                  const Spacer(),
                  MyButton(
                    color: Colors.blue,
                    title: 'إلغاء',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget nputfiled({nput}) {
    return Expanded(
      child: Container(
        child: TextFormField(
          controller: nput,
          decoration: const InputDecoration(
            labelText: 'Name Department',
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
