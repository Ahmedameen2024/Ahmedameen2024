import 'package:flutter/material.dart';

class AppResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget laptop;
  final Widget desktop;
  final Widget smart;

  const AppResponsive(
      {super.key,
      required this.mobile,
      required this.tablet,
      required this.laptop,
      required this.desktop,
      required this.smart});
  static bool isMobile(context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  static bool isLaptop(context) =>
      MediaQuery.of(context).size.width >= 1024 &&
      MediaQuery.of(context).size.width < 1440;
  static bool isDesktop(context) =>
      MediaQuery.of(context).size.width >= 1440 &&
      MediaQuery.of(context).size.width < 1920;
  static bool isSmart(context) => MediaQuery.of(context).size.width >= 1920;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final Size size = MediaQuery.of(context).size;
    if (isSmart(context)) {
      return smart;
    } else if (isDesktop(context)) {
      return desktop;
    } else if (isLaptop(context)) {
      return laptop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
