import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:hci_customer/controllers/prescript_controller.dart';
import 'package:hci_customer/models/prescription.dart';

import 'prescription_history_tile.dart';

class PresciptionHistoryScree extends StatelessWidget {
  PresciptionHistoryScree({Key? key}) : super(key: key);

  final List<Prescription> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription History'),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: const Icon(Icons.menu_rounded),
        ),
      ),
      body: SingleChildScrollView(
          child: GetX<PreScripController>(
        init: PreScripController(),
        builder: (prescrip) {
          if (prescrip.prescription.isEmpty) {
            return const Center(
                child: Text('You don\'t have any Drug Presription'));
          } else {
            return Column(
              children: [
                const SizedBox(height: 10),
                ...prescrip.prescription
                    .map((e) => PresciptionHistoryTile(e))
                    .toList()
              ],
            );
          }
        },
      )),
    );
  }
}
