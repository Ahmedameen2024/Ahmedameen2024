// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<List<Map<String, dynamic>>> getGraduatesData() async {
//   List<Map<String, dynamic>> graduatesList = [];

//   try {
//     // جلب جميع وثائق الخريجين
//     QuerySnapshot graduatesSnapshot =
//         await FirebaseFirestore.instance.collection('graduates').get();

//     for (var gradDoc in graduatesSnapshot.docs) {
//       // بيانات الخريج الأساسية
//       Map<String, dynamic> graduateData =
//           gradDoc.data() as Map<String, dynamic>;

//       // جلب بيانات المستخدم (الاسم)
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(gradDoc['userId'])
//           .get();
//       Map<String, dynamic> userData =
//           userSnapshot.data() as Map<String, dynamic>;

//       // جلب بيانات القسم
//       DocumentSnapshot departmentSnapshot = await FirebaseFirestore.instance
//           .collection('departments')
//           .doc(gradDoc['departmentId'])
//           .get();
//       Map<String, dynamic> departmentData =
//           departmentSnapshot.data() as Map<String, dynamic>;

//       // جلب بيانات الكلية
//       DocumentSnapshot collegeSnapshot = await FirebaseFirestore.instance
//           .collection('colleges')
//           .doc(gradDoc['collegeId'])
//           .get();
//       Map<String, dynamic> collegeData =
//           collegeSnapshot.data() as Map<String, dynamic>;

//       // تجميع البيانات
//       graduatesList.add({
//         'name': userData['name'],
//         'department': departmentData['name'],
//         'college': collegeData['name'],
//         'year': graduateData['graduationYear'],
//       });
//     }
//   } catch (e) {
//     print("Error fetching data: $e");
//   }

//   return graduatesList;
// }
