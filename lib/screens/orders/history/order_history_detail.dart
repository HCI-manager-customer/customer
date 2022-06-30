import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hci_customer/models/order.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../icons/my_flutter_app_icons.dart';
import 'drug_order_history_tile.dart';

class OrderHistoryDetail extends StatelessWidget {
  const OrderHistoryDetail(this.id, this.order);

  final String id;
  final Order order;

  @override
  Widget build(BuildContext context) {
    final stream =
        FirebaseFirestore.instance.collection('orders').doc(id).snapshots();
    var formatter = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Order Date: ${DateFormat('dd MMMM, yyyy').format(order.date)}'),
            const SizedBox(height: 15),
            Text('Price: ${formatter.format(order.price)},000 VND'),
            const SizedBox(height: 15),
            Text('Items: ${order.listCart.length}'),
            const SizedBox(height: 15),
            const Text('Your Order Status:'),
            const SizedBox(height: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: timelineOrder(order.status)),
            ),
            Flexible(
              child: ListView(
                children:
                    order.listCart.map((e) => DrugOrderHistoryTile(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class timelineOrder extends StatelessWidget {
  const timelineOrder(this.status);

  final String status;

  IndicatorStyle current() {
    return IndicatorStyle(
      width: 60,
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
          fontSize: 60,
          color: Colors.green,
          iconData: Icons.chevron_right_sharp),
    );
  }

  IndicatorStyle notHere() {
    return IndicatorStyle(
      width: 60,
      color: Colors.grey,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
        fontSize: 40,
        color: Colors.grey,
        iconData: Icons.circle_outlined,
      ),
    );
  }

  IndicatorStyle passHere() {
    return IndicatorStyle(
      width: 60,
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
        fontSize: 40,
        color: Colors.green,
        iconData: Icons.check,
      ),
    );
  }

  List<Widget> timeLine() {
    List<IndicatorStyle> list;
    print(status);
    Widget indi;
    if (status == 'NewOrder') {
      list = [current(), notHere(), notHere()];
    } else if (status == 'Shipping') {
      list = [passHere(), current(), notHere()];
    } else {
      list = [passHere(), passHere(), passHere()];
    }
    return [
      TimelineTile(
        isFirst: true,
        isLast: false,
        indicatorStyle: list[0],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          MyFlutterApp.clinicMedical,
          color: Colors.green,
        ),
        endChild: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Pending'),
            ),
          ),
        ),
      ),
      TimelineTile(
        isFirst: false,
        isLast: false,
        indicatorStyle: list[1],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          Icons.delivery_dining,
          color: Colors.green,
        ),
        endChild: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Shipping'),
            ),
          ),
        ),
      ),
      TimelineTile(
        isFirst: false,
        isLast: true,
        indicatorStyle: list[2],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          Icons.home,
          color: Colors.green,
        ),
        endChild: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Complete'),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: timeLine(),
    );
  }
}
