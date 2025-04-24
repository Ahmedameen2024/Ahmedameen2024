import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/table_departmentData.dart';
import 'package:flutter_application_10/shard/app_colors.dart';

class Dashbords extends StatefulWidget {
  const Dashbords({super.key});

  @override
  State<Dashbords> createState() => _DashbordsState();
}

class _DashbordsState extends State<Dashbords> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.maincolor, borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          // Hederbardashbord(
          //   page_name: 'Dashbord',
          // ),
          // Divider(
          //   height: 5,
          // ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      children: [
                        // TableCollagedata(),
                        TableDepartmentdata(),
                        // TablGriduintdata(),
                        // Research(),
                        // Toustion()
                      ],
                    ),
                  ))
            ],
          ))
        ],
      ),
    );
  }
}
