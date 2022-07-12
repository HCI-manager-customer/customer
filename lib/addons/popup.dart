import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void popUpImage(String img, String tag) {
  Get.dialog(
    SizedBox(
      width: Get.width * 0.8,
      height: Get.height * 0.5,
      child: FittedBox(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: img,
            placeholder: (_, url) => Lottie.asset(
              'assets/json-gif/image-loading.json',
              height: 100,
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
            errorWidget: (_, url, er) => Lottie.asset(
              'assets/json-gif/image-loading.json',
              alignment: Alignment.center,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    ),
  );
}
