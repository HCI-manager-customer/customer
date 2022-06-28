import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hci_customer/models/prescription.dart';
import 'package:lottie/lottie.dart';

class PresciptionHistoryTile extends StatelessWidget {
  const PresciptionHistoryTile(this.preS);
  final Prescription preS;

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Image.network(
      //   preS.Imgurl,
      //   width: 200,
      // ),
      child: CachedNetworkImage(
        height: 100,
        imageUrl: preS.Imgurl,
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
    );
  }
}
