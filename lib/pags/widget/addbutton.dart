import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // أضف هذا الاستيراد

class Addbutton {
  // ignore: non_constant_identifier_names
  static void ShowCustomDilalog({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    TextEditingController? description, // ← إضافة الحقل الجديد
  }) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String? selectedAdminUid; // متغير خارجي
    // final TextEditingController adminNameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    Future<List<Map<String, dynamic>>> fetchAdmins() async {
      try {
        final usersSnapshot =
            await _firestore.collection('Users').orderBy('uid').get();
        final adminsSnapshot =
            await _firestore.collection('Admain').orderBy('User_ID').get();

        final adminUserIds = adminsSnapshot.docs
            .map((doc) => doc['User_ID'].toString().trim())
            .toSet();

        print(
            'uids in Users: ${usersSnapshot.docs.map((doc) => doc['uid']).toList()}');
        print(
            'User_IDs in Admain: ${adminsSnapshot.docs.map((doc) => doc['User_ID']).toList()}');

        return usersSnapshot.docs
            .where((doc) => adminUserIds.contains(doc['uid'].toString().trim()))
            .map((doc) => {
                  'uid': doc['uid'],
                  'name': doc['userName'], // ← هنا التعديل الصحيح
                })
            .toList();
      } catch (e) {
        print('fetchAdmins error: $e');
        return [];
      }
    }

    void _saveData(List<Map<String, dynamic>> admins) async {
      String? adminValue = selectedAdminUid; // استخدم المتغير الخارجي مباشرة
      if (adminValue == null || adminValue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى إدخال أو اختيار مدير للكلية'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // جلب User_ID من جدول Admain إذا أردت التأكد
      String? userIdToSave = adminValue;
      final admainSnapshot = await _firestore
          .collection('Admain')
          .where('User_ID', isEqualTo: adminValue)
          .get();
      if (admainSnapshot.docs.isNotEmpty) {
        userIdToSave = admainSnapshot.docs.first['User_ID'];
      }

      try {
        await _firestore.collection('Colleges').add({
          'name': controller.text,
          'id_admin': userIdToSave, // <-- هنا التغيير
          'description': descriptionController.text,
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
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          titlePadding: const EdgeInsets.symmetric(horizontal: 30),
          content: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchAdmins(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final admins = snapshot.data ?? [];
              return StatefulBuilder(
                builder: (context, setState) => SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'اسم الكلية',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      admins.isNotEmpty
                          ? Column(
                              children: admins
                                  .map((admin) => RadioListTile<String>(
                                        title: Text(admin['name'] ?? 'No Name'),
                                        value: admin['uid'],
                                        groupValue: selectedAdminUid,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAdminUid =
                                                value; // يتم التحديث هنا
                                          });
                                        },
                                      ))
                                  .toList(),
                            )
                          : const Text('لا يوجد مدراء'),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'نبذة تعريفية عن الكلية',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                // نعيد بناء زر الحفظ ليأخذ قائمة المدراء
                final admins = (ModalRoute.of(context)?.settings.arguments
                        as List<Map<String, dynamic>>?) ??
                    [];
                return Row(
                  children: [
                    MyButton(
                      color: Colors.blue,
                      title: 'حفظ',
                      onPressed: () {
                        _saveData(admins);
                      },
                    ),
                    const Spacer(),
                    MyButton(
                      color: Colors.blue,
                      title: 'إلغاء',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            ),
          ],
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
