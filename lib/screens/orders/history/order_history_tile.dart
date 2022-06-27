import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';

class OrderHistoryTile extends StatelessWidget {
  const OrderHistoryTile(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy, hh:mm a').format(order.date);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'Order Date: $date',
                style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Price: ${order.price.toStringAsFixed(3)}',
                    style: const TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Items: ${order.listCart.length}',
                    style: const TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.listCart.length >= 2 ? 2 : 1,
            itemBuilder: (context, i) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                leading: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Image.network(
                    order.listCart[i].drug.imgUrl,
                    cacheHeight: 500,
                  ),
                ),
                title: Text(
                  order.listCart[i].drug.fullName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(letterSpacing: 1, fontSize: 15),
                ),
                subtitle: Text(
                    '${order.listCart[i].price.toStringAsFixed(3)} - ${order.listCart[i].quantity} ${order.listCart[i].drug.unit}'),
              );
            },
          ),
          if (order.listCart.length > 2)
            Text(
              '${order.listCart.length - 2} more',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            )
        ],
      ),
    );
  }
}
