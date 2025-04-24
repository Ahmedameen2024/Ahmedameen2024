import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/addbutton.dart';
import 'package:flutter_application_10/pags/widget/editbutton.dart';
import 'package:flutter_application_10/pags/widget/hederbardashbord.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:flutter_application_10/shard/app_colors.dart';

class TableDepartmentdata extends StatefulWidget {
  const TableDepartmentdata({super.key});
  @override
  State<TableDepartmentdata> createState() => _TableCollagedataState();
}

class _TableCollagedataState extends State<TableDepartmentdata> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 650,
        decoration: BoxDecoration(
            color: AppColors.bgcolor, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Hederbardashbord(
            page_name: 'Department',
            button: MyButton(
                color: Colors.blue,
                title: 'Add Department',
                onPressed: () {
                  Addbutton.ShowCustomDilalog(
                      context: context,
                      title: "Add department",
                      controller: TextEditingController(),
                      admin: TextEditingController(),
                      password: TextEditingController());
                }),
          ),
          Divider(thickness: 0.5, color: Colors.green),
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                //HeaderTable
                TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.green, width: 0.5),
                      ),
                    ),
                    children: [
                      // tableHedar('Department'),
                      tableHedar('Department Name'),
                      tableHedar('Department Dean'),
                      tableHedar('password Dean'),
                      tableHedar(''),
                    ]),
              ]),
          //Data Table
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  tabblRow(context,
                      // department: 10,
                      name: 'الطب',
                      image: 'images/كلية الطب .png',
                      dean: 'Dr.jamal AL Ameri',
                      password: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      // department: 10,
                      name: 'الهندسةوتقنيةالمعلومات',
                      image: 'images/كلية العلوم الإدارية .png',
                      dean: 'Ahmed'),
                  tabblRow(context,
                      name: 'العلوم التطبيقية',
                      image: 'images/كلية العلوم التطبيقية .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'العلوم الإدارية',
                      image: 'images/managmentscinecie.png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'الحقوق',
                      image: 'images/كلية الحقوق.png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'الأداب',
                      image:
                          'images/png-transparent-paper-ink-fountain-pen-ballpoint-pen-pen-and-ink-ink-textile-cosmetics-thumbnail.png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                      password: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'التربية',
                      image: 'images/كلية التربية ٣.png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                      password: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'اللغات والترجمة',
                      image: 'images/اللغات والترجمة .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                      password: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'الحاسب الالي',
                      image: 'images/الحاسب الآلي .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                      password: 'Dr.jamal AL Ameri'),
                  tabblRow(context,
                      name: 'التعليم المستمر',
                      image: 'images/كلية العلوم الإدارية .png',
                      // department: 10,
                      dean: 'Dr.jamal AL Ameri',
                      password: 'Dr.jamal AL Ameri'),
                ],
              ),
            ),
          )
          //   ],
          // )
        ]),
      ),
    );
  }

  TableRow tabblRow(
    context, {
    name,
    image,
    department,
    dean,
    password,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.asset(
                    "$image",
                    // height: 40,
                    width: 60,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(name),
              ],
            ),
          ),
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
              Text(dean),
            ],
          ),
          Text('$password'),
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
                                    admin: TextEditingController(),
                                    password: TextEditingController());
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
