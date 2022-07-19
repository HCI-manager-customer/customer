import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:hci_customer/controllers/order_controller.dart';
import 'package:hci_customer/models/global.dart';

import '../../../models/order.dart';
import 'order_history_tile.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(OrderController());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<OrderController>();
  }

  List<Order> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: const Icon(Icons.menu_rounded),
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.sort),
              itemBuilder: (_) {
                return [
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Sort By Date (ASC)'),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Sort By Date (DESC)'),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Sort By Name (ASC)'),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Sort By Name (DESC)'),
                  ),
                ];
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: GetX<OrderController>(
            init: OrderController(),
            builder: (ordersCtl) {
              if (ordersCtl.orders.isEmpty) {
                return const Center(
                  child: Text(
                    'You don\'t have any order',
                    style: TextStyle(fontSize: 25),
                  ),
                );
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    ...ordersCtl.orders
                        .map((e) => OrderHistoryTile(e))
                        .toList(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future getList() async {
    final orderDB = db.collection('orders');
    await orderDB
        .where('user.mail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      for (var e in value.docs) {
        list.add(Order.fromMap(e.data()));
      }
    });
    return list;
  }
}
