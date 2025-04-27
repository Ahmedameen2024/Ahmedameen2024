// ignore_for_file: use_build_context_synchronously, unused_field, unused_element, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/pags/widget/table_Collagedata.dart';
import 'package:email_validator/email_validator.dart';

class SinIn extends StatefulWidget {
  static const String sinInScreenRout = 'SinIn';
  const SinIn({super.key});

  @override
  State<SinIn> createState() => _SinInState();
}

class _SinInState extends State<SinIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال رابط التحقق إلى بريدك')),
        );
        return;
      }

      Navigator.pushReplacementNamed(
          context, TableCollagedata.TableCollagedataRout);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleAuthError(FirebaseAuthException e, BuildContext context) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-email':
        errorMessage = 'تنسيق البريد الإلكتروني غير صالح';
        break;
      case 'user-not-found':
        errorMessage = 'البريد الإلكتروني غير مسجل';
        break;
      case 'wrong-password':
        errorMessage = 'كلمة المرور غير صحيحة';
        break;
      case 'user-disabled':
        errorMessage = 'الحساب معطل';
        break;
      case 'too-many-requests':
        errorMessage = 'طلبات كثيرة، حاول لاحقًا';
        break;
      default:
        errorMessage = 'خطأ غير متوقع: ${e.message}';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _handleSignIn() {
    if (!_isLoading) {
      _signIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset('images/كلية الطب .png'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@domain.com',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!EmailValidator.validate(value.trim())) {
                    return 'تنسيق البريد غير صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 5) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      color: Colors.blue,
                      title: 'تسجيل الدخول',
                      onPressed: () => _signIn(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

extension on Type {
  get instance => null;
}
