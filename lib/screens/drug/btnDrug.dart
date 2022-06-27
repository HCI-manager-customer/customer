import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hci_customer/constant/constant.dart';
import 'package:hci_customer/screens/prescription/presciption_screen.dart';

import '../../models/category.dart';
import 'load_more/load_more.dart';

class ButtonDrug extends StatelessWidget {
  const ButtonDrug(this.cat);

  final Category cat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          if (cat.type == 'camera') {
            return const PrescriptionScreen();
          } else {
            return Obx(() {
              final list = drugController.drugs
                  .where((e) => e.type == cat.type)
                  .toList();
              return LoadMoreScreen(title: cat.title, list: list);
            });
          }
        }),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ListTile(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5)),
          leading: SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              child: Icon(cat.url, color: Colors.green),
            ),
          ),
          title: Text(
            textAlign: TextAlign.center,
            cat.title,
            maxLines: 2,
            style: const TextStyle(wordSpacing: 1, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
