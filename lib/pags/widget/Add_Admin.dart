import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_admin.dart';
import 'package:flutter_application_10/pags/widget/create_admin.dart';

class AddAdminPage extends StatelessWidget {
  const AddAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المدراء'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('إنشاء مدير'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateAdminScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Admain').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final admins = snapshot.data!.docs;
          if (admins.isEmpty) {
            return const Center(child: Text('لا يوجد مدراء'));
          }
          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              final uid = admin['uid'];
              final typeId = admin['typeId'];
              final data = admin.data() as Map<String, dynamic>? ?? {};
              final collegeId =
                  data.containsKey('collegeId') ? data['collegeId'] : null;
              final departments = data.containsKey('departments')
                  ? List<String>.from(data['departments'])
                  : null;

              return FutureBuilder<Map<String, dynamic>>(
                future: _getAdminDetails(uid, typeId, collegeId, departments),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: LinearProgressIndicator(),
                    );
                  }
                  final data = snapshot.data!;
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    'اسم المدير: ${data['userName'] ?? '-'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'تعديل',
                                onPressed: () {
                                  // يمكنك هنا فتح صفحة التعديل أو Dialog
                                  _showEditDialog(context, admin['uid']);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'حذف',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('تأكيد الحذف'),
                                      content: const Text(
                                          'هل أنت متأكد من حذف هذا المدير؟'),
                                      actions: [
                                        TextButton(
                                          child: const Text('إلغاء'),
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                        ),
                                        TextButton(
                                          child: const Text('حذف'),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await FirebaseFirestore.instance
                                        .collection('Admain')
                                        .doc(admin['uid'])
                                        .delete();
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(admin['uid'])
                                        .delete();
                                    // يمكنك حذف بيانات إضافية إذا لزم الأمر
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('تم حذف المدير بنجاح')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Text('رقم الهاتف: ${data['phone'] ?? '-'}'),
                          Text('البريد الإلكتروني: ${data['email'] ?? '-'}'),
                          Text('نوع الإدارة: ${data['type'] ?? '-'}'),
                          if (data['collegeName'] != null)
                            Text('الكلية: ${data['collegeName']}'),
                          if (data['departments'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Text('الأقسام:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ...List<Widget>.from(
                                  (data['departments']
                                          as List<Map<String, String>>)
                                      .map((dep) => Text(
                                            '${dep['departmentName']} (الكلية: ${dep['collegeName']})',
                                          )),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // دالة لجلب بيانات المدير من الجداول المختلفة
  Future<Map<String, dynamic>> _getAdminDetails(
    String uid,
    String typeId,
    String? collegeId,
    List<String>? departments,
  ) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    final typeDoc = await FirebaseFirestore.instance
        .collection('Administration_Type')
        .doc(typeId)
        .get();

    String? userName = userDoc.data()?['userName'];
    String? phone = userDoc.data()?['phone'];
    String? email = userDoc.data()?['email'];
    String? type = typeDoc.data()?['Type'];

    String? collegeName;
    if (collegeId != null) {
      final collegeDoc = await FirebaseFirestore.instance
          .collection('Colleges')
          .doc(collegeId)
          .get();
      collegeName = collegeDoc.data()?['name'];
    }

    List<Map<String, String>>? departmentsData;
    if (departments != null && departments.isNotEmpty) {
      departmentsData = [];
      for (final depId in departments) {
        final depDoc = await FirebaseFirestore.instance
            .collection('Departments')
            .doc(depId)
            .get();
        if (depDoc.exists) {
          final depName = depDoc.data()?['name'];
          final depCollegeId = depDoc.data()?['collegeId'];
          String? depCollegeName;
          if (depCollegeId != null) {
            final depCollegeDoc = await FirebaseFirestore.instance
                .collection('Colleges')
                .doc(depCollegeId)
                .get();
            depCollegeName = depCollegeDoc.data()?['name'];
          }
          departmentsData.add({
            'departmentName': depName ?? '-',
            'collegeName': depCollegeName ?? '-',
          });
        }
      }
    }

    return {
      'userName': userName,
      'phone': phone,
      'email': email,
      'type': type,
      'collegeName': collegeName,
      'departments': departmentsData,
    };
  }

  // أضف دالة التعديل البسيطة (مثال لتعديل الهاتف والإيميل فقط)
  void _showEditDialog(BuildContext context, String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    final TextEditingController phoneController =
        TextEditingController(text: userDoc.data()?['phone'] ?? '');
    final TextEditingController emailController =
        TextEditingController(text: userDoc.data()?['email'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل بيانات المدير'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('حفظ'),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid)
                  .update({
                'email': emailController.text,
                'phone': phoneController.text,
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث البيانات')),
              );
            },
          ),
        ],
      ),
    );
  }
}
