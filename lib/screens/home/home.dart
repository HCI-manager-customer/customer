// ignore_for_file: must_be_immutable

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_customer/controllers/drug_controller.dart';
import 'package:hci_customer/screens/drug/btnDrug.dart';
import '../../models/category.dart';
import '../../models/drugs.dart';
import '../cart/cart_screen.dart';
import 'smallGrid.dart';
import '../drug/load_more/load_more.dart';
import '../misc/search_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isPhone = size.shortestSide < 650 ? true : false;
    return DraggableHome(
        appBarColor: Colors.green,
        headerBottomBar: const Center(
          child: Text(
            'Pull down to search',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const CartScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: const Icon(Icons.menu_rounded),
        ),
        title: Text(
          "Pharmacy",
          style: GoogleFonts.kanit(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerWidget: _WidgetBtnGroup(isPhone, context),
        expandedBody: const SearchDialog(),
        fullyStretchable: true,
        alwaysShowLeadingAndAction: true,
        body: [
          GetX<DrugController>(
              init: DrugController(),
              builder: (drugController) {
                final drugs = drugController.drugs;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _HomeBody(context, isPhone, size, drugs),
                );
              }),
        ]);
  }

  void showSearchDialog(Size size, BuildContext context, var list) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return const SearchDialog();
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Widget _HomeBody(
      BuildContext context, bool isPhone, Size size, List<Drug> list) {
    final listA1 = list.where((e) => e.type == 'A1').toList();
    final listA2 = list.where((e) => e.type == 'A2').toList();
    list.shuffle();
    return Column(
      children: [
        _toLoadMoreScreen(context, listA1, 'Near Me'),
        const SizedBox(height: 10),
        buildSmallGrid(isPhone, list),
        _toLoadMoreScreen(context, listA1, 'Unprescribed Drugs'),
        const SizedBox(height: 10),
        buildSmallGrid(isPhone, listA1),
        _toLoadMoreScreen(context, listA2, "Medical Devices/Equipments"),
        const SizedBox(height: 10),
        buildSmallGrid(isPhone, listA2),
      ],
    );
  }

  GestureDetector _toLoadMoreScreen(
      BuildContext context, List<Drug> list, String title) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadMoreScreen(title: title, list: list),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }

  Widget _WidgetBtnGroup(bool isPhone, BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          Text(
            "Pharmacy",
            style: GoogleFonts.kanit(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ButtonDrug(iconList[0]),
                ButtonDrug(iconList[1]),
                ButtonDrug(iconList[2]),
                ButtonDrug(iconList[3]),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
