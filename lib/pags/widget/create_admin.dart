import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAdminScreen extends StatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  State<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String email = '';
  String password = '';
  String phone = '';
  String? selectedCollegeId;
  String? selectedTypeId;
  bool isLoading = false;
  bool _isAllowed = false;
  String? _userType;
  Map<String, dynamic>? _adminData;
  Map<String, dynamic>? _userData;
  String? selectedUniversityId;
  bool isChecking = true;
  List<String> selectedDepartmentIds = [];
  String? collageIdForAdmin;

  @override
  void initState() {
    super.initState();
    _checkUserPermissions();
  }

  Future<void> _checkUserPermissions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isChecking = false;
        _isAllowed = false;
      });
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    final adminDoc = await FirebaseFirestore.instance
        .collection('Admain')
        .doc(user.uid)
        .get();

    if (!userDoc.exists || !adminDoc.exists) {
      setState(() {
        isChecking = false;
        _isAllowed = false;
      });
      return;
    }

    final adminData = adminDoc.data()!;
    final typeId = adminData['typeId'];
    final typeDoc = await FirebaseFirestore.instance
        .collection('Administration_Type')
        .doc(typeId)
        .get();
    final typeName = typeDoc['Type'];

    if (typeName == 'CollageAdmain') {
      collageIdForAdmin = adminData['collegeId'];
    }

    setState(() {
      _userType = typeName;
      _adminData = adminData;
      _userData = userDoc.data();
      _isAllowed = true;
      isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء مدير')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'اسم المدير'),
                      onChanged: (val) => userName = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'البريد الإلكتروني'),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => email = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'كلمة المرور'),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) => val == null || val.length < 6
                          ? '6 أحرف على الأقل'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'رقم الهاتف'),
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => phone = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 20),
                    const Text('اختر نوع الإدارة:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Administration_Type')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator();
                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty)
                          return const Text('لا توجد أنواع إدارة');
                        return ExpansionTile(
                          title: RadioListTile<String>(
                            title: Text(docs[0]['Type']),
                            value: docs[0].id,
                            groupValue: selectedTypeId,
                            onChanged: (val) =>
                                setState(() => selectedTypeId = val),
                          ),
                          children: docs.skip(1).map((doc) {
                            return RadioListTile<String>(
                              title: Text(doc['Type']),
                              value: doc.id,
                              groupValue: selectedTypeId,
                              onChanged: (val) =>
                                  setState(() => selectedTypeId = val),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    (_userType == 'CollageAdmain')
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('اختر القسم:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Departments')
                                    .where('collegeId',
                                        isEqualTo:
                                            selectedCollegeId) // أو استخدم collegeId المناسب
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const CircularProgressIndicator();
                                  final docs = snapshot.data!.docs;
                                  if (docs.isEmpty)
                                    return const Text('لا توجد أقسام');
                                  return Column(
                                    children: docs.map((doc) {
                                      return CheckboxListTile(
                                        title: Text(doc['name']),
                                        value: selectedDepartmentIds
                                            .contains(doc.id),
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedDepartmentIds.add(doc.id);
                                            } else {
                                              selectedDepartmentIds
                                                  .remove(doc.id);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('اختر الكلية:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Colleges')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const CircularProgressIndicator();
                                  final docs = snapshot.data!.docs;
                                  if (docs.isEmpty)
                                    return const Text('لا توجد كليات');
                                  return ExpansionTile(
                                    title: RadioListTile<String>(
                                      title: Text(docs[0]['name']),
                                      value: docs[0].id,
                                      groupValue: selectedCollegeId,
                                      onChanged: (val) => setState(
                                          () => selectedCollegeId = val),
                                    ),
                                    children: docs.skip(1).map((doc) {
                                      return RadioListTile<String>(
                                        title: Text(doc['name']),
                                        value: doc.id,
                                        groupValue: selectedCollegeId,
                                        onChanged: (val) => setState(
                                            () => selectedCollegeId = val),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      child: const Text('إنشاء مدير'),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate() ||
                            selectedTypeId == null ||
                            (_userType == 'CollageAdmain'
                                ? selectedDepartmentIds.isEmpty
                                : selectedCollegeId == null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'يرجى تعبئة جميع الحقول واختيار القسم أو الكلية والنوع')),
                          );
                          return;
                        }
                        setState(() => isLoading = true);
                        UserCredential? userCredential;
                        try {
                          // 1. إنشاء مستخدم جديد
                          userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final uid = userCredential.user!.uid;

                          // 2. إضافة بيانات المدير إلى جدول Users
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(uid)
                              .set({
                            'uid': uid,
                            'userName': userName,
                            'email': email,
                            'password': password,
                            'phone': phone,
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                          // 3. إضافة بيانات المدير إلى جدول Admain
                          await FirebaseFirestore.instance
                              .collection('Admain')
                              .doc(uid)
                              .set({
                            'uid': uid,
                            // 'collegeId': _userType == 'CollageAdmain'
                            //     ? collageIdForAdmin
                            //     : selectedCollegeId,
                            'typeId': selectedTypeId,
                            'departments': selectedDepartmentIds,
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('تم إنشاء المدير بنجاح')),
                            );
                            Navigator.pop(context);
                          }
                        } on FirebaseAuthException catch (e) {
                          if (userCredential != null) {
                            // حذف المستخدم إذا فشل أي جزء بعد الإنشاء
                            await userCredential.user!.delete();
                          }
                          String msg = 'فشل إنشاء الحساب';
                          if (e.code == 'email-already-in-use')
                            msg = 'البريد الإلكتروني مستخدم مسبقاً';
                          if (e.code == 'weak-password')
                            msg = 'كلمة المرور ضعيفة';
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(msg)));
                        } catch (e) {
                          if (userCredential != null) {
                            await userCredential.user!.delete();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('حدث خطأ: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => isLoading = false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
