import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive(this.mobileBody, this.tableBody, this.webBody);

  final Widget mobileBody;
  final Widget tableBody;
  final Widget webBody;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 730;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1190 &&
      MediaQuery.of(context).size.width >= 730;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1190;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimen) {
        if (isMobile(context)) {
          return mobileBody;
        } else if (isTablet(context)) {
          return tableBody;
        } else {
          return webBody;
        }
      },
    );
  }
}