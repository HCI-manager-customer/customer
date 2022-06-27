import 'package:flutter/material.dart';
import 'package:hci_customer/models/prescription.dart';

class PresciptionHistoryTile extends StatelessWidget {
  const PresciptionHistoryTile(this.preS);
  final Prescription preS;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        preS.Imgurl,
        width: 200,
      ),
    );
  }
}
