import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/addbutton.dart';
import 'package:flutter_application_10/pags/widget/editbutton.dart';
import 'package:flutter_application_10/pags/widget/hederbardashbord.dart';
import 'package:flutter_application_10/pags/my_botton.dart';
import 'package:flutter_application_10/shard/app_colors.dart';
import 'package:flutter_application_10/shard/app_responsive.dart';

class TablGriduintdata extends StatefulWidget {
  const TablGriduintdata({super.key});

  @override
  State<TablGriduintdata> createState() => _TableCollagedataState();
}

class _TableCollagedataState extends State<TablGriduintdata> {
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
            page_name: 'Gradiants',
            button: MyButton(
                color: Colors.blue,
                title: 'Add Gradant',
                onPressed: () {
                  Addbutton.ShowCustomDilalog(
                      context: context,
                      title: "Add Graduants",
                      controller: TextEditingController(),
                      // admin: TextEditingController(),
                      description: TextEditingController());
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
                    tableHedar('Name'),
                    if (!AppResponsive.isMobile(context) &&
                        !AppResponsive.isTablet(context))
                      tableHedar('User_Name'),
                    if (!AppResponsive.isMobile(context) &&
                        !AppResponsive.isTablet(context))
                      tableHedar('Email'),
                    if (!AppResponsive.isMobile(context) &&
                        !AppResponsive.isTablet(context))
                      tableHedar('Phone'),
                    tableHedar('Collage'),
                    // tableHedar('Deparment'),
                    tableHedar('Address'),
                    tableHedar('Opreations'),
                  ]),
            ],
          ),
          //Data Table
          Expanded(
              child: SingleChildScrollView(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                tabblRow(
                  context,
                  name: 'Ahmed Ameen Ahmed',
                  username: 'Ahmed',
                  // image: 'images/كلية الطب .png',
                  emaill: 'AAAAA',
                  phone: '7144',
                  department: 'Computer',
                  collage: 'Dr.jamal AL Ameri',
                  address: ' Taze_Alomast_INyosaf aqa',
                )
              ],
            ),
          ))
        ]),
      ),
    );
  }

  TableRow tabblRow(
    context, {
    name,
    username,
    emaill,
    phone,
    // image,
    department,
    collage,
    address,
  }) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.green, width: 0.5),
          ),
        ),
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(1000),
                //   child: Image.asset(
                //     "$image",
                //     // height: 40,
                //     width: 60,
                //   ),
                // ),
                Text(name),

                // Text(name),
              ],
            ),
          ),
          if (!AppResponsive.isMobile(context) &&
              !AppResponsive.isTablet(context))
            Text(username),
          if (!AppResponsive.isMobile(context) &&
              !AppResponsive.isTablet(context))
            Text(emaill),
          if (!AppResponsive.isMobile(context) &&
              !AppResponsive.isTablet(context))
            Text(phone),
          Row(
            children: [
              Text(collage),
              // Container(
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle, color: AppColors.maincolor),
              //     height: 10,
              //     width: 10),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Text(department),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(1000),
                //   child: Image.asset(
                //     "$image",
                //     // height: 40,
                //     width: 60,
                //   ),
                // ),
                Text(address),

                // Text(name),
              ],
            ),
          ),
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
                                  title: 'Add collage',
                                  controller: TextEditingController(),
                                  description: TextEditingController(),
                                );
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
