// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../icons/my_flutter_app_icons.dart';

class Category {
  final String title;
  final IconData iconUrl;
  final String type;

  Category(this.title, this.iconUrl, this.type);
}

List<Category> iconList = [
  Category('Unprescribed Drugs', MyFlutterApp.capsules, 'A1'),
  Category('Medical Equipment', MyFlutterApp.briefcaseMedical, 'A2'),
  Category('Prescription Picture', MyFlutterApp.prescriptionBottle, 'camera'),
  Category('Nearby Pharmacy', MyFlutterApp.clinicMedical, 'A4'),
];
