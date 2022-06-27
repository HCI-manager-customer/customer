import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_customer/constant/constant.dart';
import 'package:hci_customer/screens/prescription/presciption_screen.dart';

import '../../models/category.dart';
import '../misc/nearby.dart';
import 'load_more/load_more.dart';

class ButtonDrug extends StatelessWidget {
  const ButtonDrug(this.cat);

  final Category cat;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.lightBlue;
    switch (cat.type) {
      case 'A1':
        color = Colors.teal;
        break;
      case 'A2':
        color = Colors.lightBlue;
        break;
      case 'camera':
        color = Colors.deepPurple;
        break;
      case 'A4':
        color = Colors.pink;
        break;
    }
    return GestureDetector(
      onTap: () {
        if (cat.type == 'camera') {
          Get.to(() => const PrescriptionScreen());
        } else if (cat.type == 'A4') {
          Get.to(() => const NearbyStoreScreen());
        } else {
          Get.to(() => Obx(() {
                final list = drugController.drugs
                    .where((e) => e.type == cat.type)
                    .toList();
                return LoadMoreScreen(title: cat.title, list: list);
              }));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          // width: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 200,
                  width: 200,
                  child: Icon(
                    cat.iconUrl,
                    size: 80,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        color.withOpacity(0.4),
                        color.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    cat.title,
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
