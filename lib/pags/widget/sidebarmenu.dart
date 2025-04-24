import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/widget/research.dart';
import 'package:flutter_application_10/pags/widget/table_griduintData.dart';
import 'package:flutter_application_10/shard/app_colors.dart';
import 'package:flutter_application_10/shard/app_responsive.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: AppColors.bgsidemenu,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (AppResponsive.isLaptop(context)) ...{
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text('Control Panal',
                      style: TextStyle(
                          color: AppColors.fontcolormain,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
              },
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              //   child: Text('Control Panal',
              //       style: TextStyle(
              //           color: AppColors.fontcolormain,
              //           fontSize: 25,
              //           fontWeight: FontWeight.bold)),
              // ),
              Drowerlist(
                icon: Icon(Icons.dashboard),
                title: 'Dashbord',
                press: () {},
              ),
              Drowerlist(
                icon: Icon(Icons.group),
                title: 'Admnis',
                press: () {},
              ),
              Drowerlist(
                icon: Icon(Icons.food_bank),
                title: 'collage',
                press: () {},
              ),
              Drowerlist(
                icon: Icon(Icons.school),
                title: 'Grduints',
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TablGriduintdata()));
                },
              ),
              Drowerlist(
                icon: Icon(Icons.book),
                title: 'Research',
                press: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Research()));
                },
              ),
              Drowerlist(
                icon: Icon(Icons.bookmark),
                title: 'Stdy Plan',
                press: () {},
              ),
              Drowerlist(
                icon: Icon(Icons.list_alt),
                title: 'job',
                press: () {},
              ),
              Drowerlist(
                icon: Icon(Icons.people_alt),
                title: 'Users',
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Drowerlist extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback press;

  const Drowerlist(
      {super.key,
      required this.title,
      required this.icon,
      required this.press});

  // const Drowerlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Row(
        children: [
          if (!AppResponsive.isTablet(context))
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
        ],
      ),
      onTap: press,
    );
  }
}
