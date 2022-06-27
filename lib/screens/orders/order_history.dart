import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hci_customer/models/global.dart';

import '../../models/order.dart';
import '../../models/order.dart';
import 'order_history_tile.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder(
            future: getList(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (list.isEmpty) {
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
                    ...list.map((e) => OrderHistoryTile(e)).toList(),
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
    // await orderDB.get().then((value) {
    //   for (var e in value.docs) {
    //     if (e.data()['user']['mail'] ==
    //         FirebaseAuth.instance.currentUser!.email) {
    //       list.add(Order.fromMap(e.data()));
    //     }
    //   }
    // });
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
