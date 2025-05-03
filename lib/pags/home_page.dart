import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/dashbord/dashbord.dart';
import 'package:flutter_application_10/pags/widget/sidebarmenu.dart';
import 'package:flutter_application_10/shard/app_colors.dart';
import 'package:flutter_application_10/shard/app_responsive.dart';
import 'package:flutter_application_10/control/menu_controller.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class Home_page extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String home_pageControScreenRout = 'home_pageControl';

  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

    // ignore: unused_local_variable
    var user = ModalRoute.of(context)!.settings.arguments;
    // ignore: unused_local_variable
    var email = ModalRoute.of(context)!.settings.arguments;
    // ignore: unused_local_variable
    var password = ModalRoute.of(context)!.settings.arguments;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: w < 600 ? null : Sidebar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      // key: Provider.of<MenuController>(context, listen: false).scaffuldKey,
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//sidemenu
          if (AppResponsive.isSmart(context)) ...{
            Expanded(child: Sidebar()),
          },

          if (AppResponsive.isDesktop(context)) ...{
            Expanded(child: Sidebar()),
          },
          if (AppResponsive.isLaptop(context)) ...{
            Expanded(child: Sidebar()),
          },
          if (AppResponsive.isTablet(context)) ...{
            Expanded(child: Sidebar()),
          },
          if (AppResponsive.isMobile(context)) ...{},
          Expanded(
            flex: 4,
            child: Dashbords(),
          ),
        ],
      )),
    );
    // ignore: dead_code
  }
}
