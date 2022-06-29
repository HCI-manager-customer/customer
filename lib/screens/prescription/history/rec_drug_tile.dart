import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../models/drugs.dart';

class RecDrugTile extends StatelessWidget {
  const RecDrugTile(this.drug, this.vol);

  final Drug drug;
  final int vol;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        height: 100,
        width: 80,
        memCacheHeight: 500,
        imageUrl: drug.imgUrl,
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
      title: Text(
        drug.fullName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${drug.price.toStringAsFixed(3)} VND x $vol items'),
      // trailing: Row(
      //   children: [
      //     Text(drug.rating.toStringAsFixed(1)),
      //     const Icon(
      //       Icons.star,
      //       color: Colors.yellow,
      //     ),
      //   ],
      // ),
    );
  }
}
