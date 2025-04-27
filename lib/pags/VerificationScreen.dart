// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  static const String verificationScreenRoute =
      'VerificationScreen'; // أضف هذا السطر

  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'تحقق من بريدك الإلكتروني واضغط على الرابط',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // زر إعادة إرسال الرابط
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.emailVerified) {
                  await user.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إعادة إرسال الرابط إلى بريدك'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'إعادة إرسال الرابط',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            // زر التحديث والتحقق
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.reload(); // تحديث حالة المستخدم
                  final updateduser = FirebaseAuth.instance.currentUser;

                  if (updateduser != null && updateduser.emailVerified) {
                    // إذا تم التحقق، انتقل إلى الشاشة الرئيسية
                    Navigator.pushReplacementNamed(context, 'WelcomScreen');
                    // Navigator.pushReplacementNamed(context, 'HomeScreen'); WelcomScreen
                  } else {
                    // إذا لم يتم التحقق، عرض رسالة
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لم يتم التحقق بعد، تحقق من بريدك'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                'تحديث الحالة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
