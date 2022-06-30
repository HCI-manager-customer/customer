import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hci_customer/screens/drug/info.dart';

import '../../../models/cart.dart';

class DrugOrderHistoryTile extends StatelessWidget {
  const DrugOrderHistoryTile(this.cart);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => InfoScreen(cart.drug));
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        leading: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Image.network(
            cart.drug.imgUrl,
            cacheHeight: 500,
          ),
        ),
        title: Text(
          cart.drug.fullName,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: const TextStyle(letterSpacing: 1, fontSize: 15),
        ),
        subtitle: Text(
            '${cart.price.toStringAsFixed(3)} - ${cart.quantity} ${cart.drug.unit}'),
      ),
    );
  }
}
