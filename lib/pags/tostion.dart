import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/addbutton.dart';
import 'package:flutter_application_10/pags/widget/editbutton.dart';
import 'package:flutter_application_10/shard/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_10/pags/sin_in.dart';

class Toustion extends StatefulWidget {
  const Toustion({super.key});

  @override
  State<Toustion> createState() => _ToustionState();
}

class _ToustionState extends State<Toustion> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed(SinIn.sinInScreenRout);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب تسجيل الدخول أولاً'),
            backgroundColor: Colors.red,
          ),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر إضافة كلية
            Row(
              children: [
                Text('Toustion'),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Addbutton.ShowCustomDilalog(
                      context: context,
                      title: 'Add collage',
                      controller: TextEditingController(),
                      description: TextEditingController(),
                    );
                  },
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              ],
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
                    tableHedar('Department Name'),
                    tableHedar('collage_name'),
                    tableHedar('public'),
                    tableHedar('privet '),
                    tableHedar('privet s'),
                    tableHedar(''),
                  ],
                ),
              ],
            ),
            // بيانات الجدول
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    tabblRow(
                      context,
                      // department: 10,
                      department_name: 'الطب',
                      collage_name: 'الطب',
                      public: '2500',
                      privet: '25000',
                      dean: '20',
                    ),
                    tabblRow(context,
                        // department: 10,
                        department_name: 'bilal',
                        collage_name: 'الطب',
                        public: '2500',
                        privet: '25000',
                        // image: 'images/كلية العلوم الإدارية .png',
                        dean: 'Ahmed'),
                    tabblRow(context,
                        department_name: 'bilal',
                        collage_name: 'الطب',
                        public: '2500',
                        privet: '25000',
                        // image: 'images/كلية العلوم التطبيقية .png',
                        // department: 10,
                        dean: 'Dr.jamal AL Ameri'),
                    tabblRow(context,
                        department_name: 'bilal',
                        collage_name: 'الطب',
                        public: '2500',
                        privet: '25000',
                        // image: 'images/managmentscinecie.png',
                        // department: 10,
                        dean: 'Dr.jamal AL Ameri'),
                    tabblRow(context,
                        department_name: 'bilal',
                        collage_name: 'الطب',
                        public: '2500',
                        privet: '25000',
                        // image: 'images/كلية الحقوق.png',
                        // department: 10,
                        dean: 'Dr.jamal AL Ameri'),
                    tabblRow(
                      context,
                      department_name: 'bilal',
                      collage_name: 'الطب',
                      public: '2500',
                      privet: '25000',
                      // image:
                      //     'images/png-transparent-paper-ink-fountain-pen-ballpoint-pen-pen-and-ink-ink-textile-cosmetics-thumbnail.png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                    ),
                    tabblRow(
                      context,
                      department_name: 'bilal',
                      collage_name: 'الطب',
                      public: '2500',
                      privet: '25000',
                      // image: 'images/كلية التربية ٣.png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                    ),
                    tabblRow(
                      context,
                      department_name: 'bilal',
                      collage_name: 'الطب',
                      public: '2500',
                      privet: '25000',
                      // image: 'images/اللغات والترجمة .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                    ),
                    tabblRow(
                      context,
                      department_name: 'bilal',
                      collage_name: 'الطب',
                      public: '2500',
                      privet: '25000',
                      // image: 'images/الحاسب الآلي .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                    ),
                    tabblRow(
                      context,
                      department_name: 'bilal',
                      collage_name: 'الطب',
                      public: '2500',
                      privet: '25000',
                      // image: 'images/كلية العلوم الإدارية .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow tabblRow(
    context, {
    department_name,
    public,
    privet,
    dean,
    collage_name,
  }) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.green, width: 0.5),
          ),
        ),
        children: [
          // Text('$department'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(1000),
                //   child: Image.asset(
                //     "$image",
                //     // height: 40,
                //     width: 60,
                //   ),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                Text(department_name),
              ],
            ),
          ),
          Text(collage_name),
          Row(
            children: [
              // Container(
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle, color: AppColors.maincolor),
              //     height: 10,
              //     width: 10),
              SizedBox(
                width: 10,
              ),
              Text(public),
            ],
          ),
          Text(dean),
          Text(privet),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Editbutton.showAlert(
                        context: context,
                        title: 'Edit',
                        content: Text('Bilalaa dfhjgfsbvs hfhgfjgf ?'),
                        action: [
                          TextButton(
                              onPressed: () {
                                Addbutton.ShowCustomDilalog(
                                    context: context,
                                    title: 'Edit collage or Admin',
                                    controller: TextEditingController(),
                                    // admin: TextEditingController(),
                                    description: TextEditingController());
                              },
                              child: Text('oke')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'))
                        ]);
                  },
                  icon: Icon(Icons.edit)),
              Icon(Icons.more_vert),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete))
            ],
          )
        ]);
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
}
