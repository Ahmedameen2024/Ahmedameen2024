import 'package:device_preview/device_preview.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_10/pags/tostion.dart';
import 'package:flutter_application_10/pags/widget/chat_screen.dart';
import 'package:flutter_application_10/pags/sin_in.dart';
import 'package:flutter_application_10/pags/VerificationScreen.dart';
import 'package:flutter_application_10/pags/sin_ub.dart';
import 'package:flutter_application_10/pags/widget/research.dart';
import 'package:flutter_application_10/pags/widget/table_collageData.dart';
import 'package:flutter_application_10/pags/widget/table_departmentData.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter_application_10/control/menu_controller.dart';
import 'package:flutter_application_10/pags/home_page.dart';

import 'package:flutter_application_10/pags/welcom_screen.dart';
import 'package:flutter_application_10/shard/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_10/pags/my_botton.dart';

import 'package:flutter_application_10/pags/widget/sidebarmenu.dart';
import 'package:flutter_application_10/pags/widget/hederbardashbord.dart';

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance
      .setPersistence(Persistence.LOCAL); // حفظ الجلسة محليًا
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        WelcomScreen.welcomScreenRout: (context) => const WelcomScreen(),
        SinIn.sinInScreenRout: (context) => const SinIn(),
        SignUp.signUpScreenRoute: (context) => const SignUp(),
        TableCollagedata.TableCollagedataRout: (context) =>
            const TableCollagedata(),
        Home_page.home_pageControScreenRout: (context) => const Home_page(),
        VerificationScreen.verificationScreenRoute: (context) =>
            const VerificationScreen(),
      },

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.emailVerified) {
            return const Test();
          } else {
            return SinIn();
          }
        },
      ),

      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasData && snapshot.data!.emailVerified) {
      //       return TableCollagedata();
      //     } else {
      //       return SinIn();
      //     }
      //   },
      // ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Map<String, dynamic>> colleges = []; // تخزين البيانات
  bool _isLoading = false;

  Future<void> getData() async {
    setState(() => _isLoading = true);

    try {
      final loadedColleges = <Map<String, dynamic>>[];

      for (final doc
          in (await FirebaseFirestore.instance.collection('Colleges').get())
              .docs) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          loadedColleges.add(data);
        }
      }

      if (!mounted) return; // أضف هذا السطر قبل setState
      setState(() {
        colleges = loadedColleges;
      });

      for (final college in colleges) {
        print(college);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      if (mounted)
        setState(() => _isLoading = false); // أضف شرط mounted هنا أيضًا
    }
  }

  @override
  void initState() {
    super.initState(); // يجب استدعاء super أولاً
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colleges List')),
      body: colleges.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: colleges.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(colleges[index]['description'] ?? 'No Name'),
                  subtitle: Text(colleges[index]['location'] ?? 'Unknown'),
                );
              },
            ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_isLoading', _isLoading));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SignUp()),
    );
  }
}







// class SinIn extends StatelessWidget {
//   // static const String sinInScreenRout = 'SinIn';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign In'),
//       ),
//       body: Center(
//         child: Text('Sign In Screen'),
//       ),
//     );
//   }
// }

















// import 'package:device_preview/device_preview.dart';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_application_10/pags/tostion.dart';
// import 'package:flutter_application_10/pags/widget/chat_screen.dart';
// import 'package:flutter_application_10/pags/sin_in.dart';
// import 'package:flutter_application_10/pags/VerificationScreen.dart';
// import 'package:flutter_application_10/pags/sin_ub.dart';
// import 'package:flutter_application_10/pags/widget/research.dart';
// import 'package:flutter_application_10/pags/widget/table_collageData.dart';
// import 'package:flutter_application_10/pags/widget/table_departmentData.dart';
// import 'firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter_application_10/control/menu_controller.dart';
// import 'package:flutter_application_10/pags/home_page.dart';

// import 'package:flutter_application_10/pags/welcom_screen.dart';
// import 'package:flutter_application_10/shard/app_colors.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_application_10/pags/my_botton.dart';

// import 'package:flutter_application_10/pags/widget/sidebarmenu.dart';
// import 'package:flutter_application_10/pags/widget/hederbardashbord.dart';

// void main() async {
//   FlutterError.onError = (details) {
//     FlutterError.presentError(details);
//     if (kReleaseMode) exit(1);
//   };

//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await FirebaseAuth.instance
//       .setPersistence(Persistence.LOCAL); // حفظ الجلسة محليًا
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
// // في الملف الرئيسي (مثل main.dart)
// // في الملف الرئيسي (main.dart)
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData && snapshot.data!.emailVerified) {
//             return TableCollagedata();
//           } else {
//             return SinIn();
//           }
//         },
//       ),
//     );
//   }
// }

// class Test extends StatefulWidget {
//   const Test({super.key}); // إضافة const وتصحيح البناء

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   List<Map<String, dynamic>> colleges = []; // تخزين البيانات
//   bool _isLoading = false;

//   Future<void> getData() async {
//     setState(() => _isLoading = true);

//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('Colleges').get();

//       final loadedColleges = <Map<String, dynamic>>[];

//       for (final doc in querySnapshot.docs) {
//         // التحقق من وجود البيانات وتجنب القيم الفارغة
//         if (doc.exists && doc.data() != null) {
//           final data = doc.data() as Map<String, dynamic>;
//           loadedColleges.add(data);
//         }
//       }

//       setState(() {
//         colleges = loadedColleges;
//       });

//       // طباعة للتحقق
//       for (final college in colleges) {
//         print(college);
//       }
//     } catch (e) {
//       print("Error fetching data: $e");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState(); // يجب استدعاء super أولاً
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Colleges List')),
//       body: colleges.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: colleges.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(colleges[index]['description'] ?? 'No Name'),
//                   subtitle: Text(colleges[index]['location'] ?? 'Unknown'),
//                 );
//               },
//             ),
//     );
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<bool>('_isLoading', _isLoading));
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: SafeArea(child: SignUp()),
//     );
//   }
// }
// //  تحقق من وجود خظأ وصححة يرجع رسالة البريد الالكتروني غير صالح عند عملية تسجيل الدخول رغم ان بريدي موجود في قاعدة البيانات

