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
                    const Text('اختر الكلية:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Colleges')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator();
                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty) return const Text('لا توجد كليات');
                        return ExpansionTile(
                          title: RadioListTile<String>(
                            title: Text(docs[0]['name']),
                            value: docs[0].id,
                            groupValue: selectedCollegeId,
                            onChanged: (val) =>
                                setState(() => selectedCollegeId = val),
                          ),
                          children: docs.skip(1).map((doc) {
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
                    const SizedBox(height: 30),
                    ElevatedButton(
                      child: const Text('إنشاء مدير'),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate() ||
                            selectedCollegeId == null ||
                            selectedTypeId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'يرجى تعبئة جميع الحقول واختيار الكلية والنوع')),
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
                            'collegeId': selectedCollegeId,
                            'typeId': selectedTypeId,
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
