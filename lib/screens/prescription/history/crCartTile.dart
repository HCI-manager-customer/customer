import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/provider/general_provider.dart';
import 'package:lottie/lottie.dart';

import '../../../models/drugs.dart';

class CurrentCartTile extends StatelessWidget {
  const CurrentCartTile(this.drug);

  final Drug drug;

  int getCartVolume(Drug d, WidgetRef ref) {
    return ref
        .watch(cartLProvider)
        .where((element) => element.drug == d)
        .first
        .quantity;
  }

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
      subtitle: Consumer(
          builder: (_, ref, __) => Text(
              '${drug.price.toStringAsFixed(3)} VND x ${getCartVolume(drug, ref)} items')),
    );
  }
}
