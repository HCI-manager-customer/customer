import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading() {
  Get.defaultDialog(
    title: 'Loading...',
    content: const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );
}

dissmissLoading() => Get.back();
