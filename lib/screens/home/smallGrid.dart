import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hci_customer/addons/responsive.dart';

import '../../models/drugs.dart';
import '../drug/product_tile.dart';

class buildSmallGrid extends StatelessWidget {
  const buildSmallGrid(this.isPhone, this.list);
  final bool isPhone;
  final List<Drug> list;

  @override
  Widget build(BuildContext context) {
    bool isNear = list.length >= 19;
    Size size = MediaQuery.of(context).size;
    int count = isPhone ? 2 : (size.width / 200).ceil();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? 50 : 0),
      child: AnimationLimiter(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisExtent: 250,
            crossAxisSpacing: Responsive.isDesktop(context) ? 20 : 10,
            mainAxisSpacing: 10,
          ),
          itemCount: isNear
              ? Responsive.isDesktop(context)
                  ? list.length
                  : 2
              : Responsive.isDesktop(context)
                  ? 7
                  : list.length > 4
                      ? 4
                      : list.length,
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredGrid(
              position: i,
              columnCount: count,
              duration: const Duration(milliseconds: 1000),
              child: ScaleAnimation(
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: DrugTile(list[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
