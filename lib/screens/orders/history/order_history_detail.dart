import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
          PopupMenuButton(onSelected: (value) {
            if (value == 'cancel') {
              Get.snackbar(
                  'You can not cancel this Order', 'Order has been delivered',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  icon: const Icon(Icons.error),
                  snackPosition: SnackPosition.BOTTOM);
            }
          }, itemBuilder: (_) {
            return [
              const PopupMenuItem(
                value: 'cancel',
                child: Text('Cancel Order'),
              ),
            ];
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date: ${DateFormat('dd MMMM, yyyy').format(order.date)}',
              style: GoogleFonts.kanit(fontSize: 20),
            ),
            const SizedBox(height: 15),
            Text(
              'Price: ${formatter.format(order.price)},000 VND',
              style: GoogleFonts.kanit(fontSize: 20),
            ),
            const SizedBox(height: 15),
            Text(
              'Items: ${order.listCart.length}',
              style: GoogleFonts.kanit(fontSize: 20),
            ),
            const SizedBox(height: 15),
            Text(
              'Your Order Status:',
              style: GoogleFonts.kanit(fontSize: 20),
            ),
            const SizedBox(height: 15),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final data = snap.data!.data()!;
                    print(data['status']);
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: timelineOrder(data['status'])),
                    );
                  }
                },
                stream: stream),
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

  LineStyle linePass() {
    return const LineStyle(color: Colors.green);
  }

  LineStyle lineNot() {
    return const LineStyle(color: Colors.grey);
  }

  List<Widget> timeLine() {
    List<IndicatorStyle> list;
    List<LineStyle> listLine;
    if (status == 'Accept Order') {
      list = [current(), notHere(), notHere()];
      listLine = [lineNot(), lineNot(), lineNot(), lineNot()];
    } else if (status == 'Shipping') {
      list = [passHere(), current(), notHere()];
      listLine = [linePass(), linePass(), lineNot(), lineNot()];
    } else {
      list = [passHere(), passHere(), passHere()];
      listLine = [linePass(), linePass(), linePass(), linePass()];
    }
    return [
      TimelineTile(
        isFirst: true,
        isLast: false,
        indicatorStyle: list[0],
        afterLineStyle: listLine[0],
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
        beforeLineStyle: listLine[1],
        afterLineStyle: listLine[2],
        indicatorStyle: list[1],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          Icons.delivery_dining,
          size: 35,
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
        beforeLineStyle: listLine[3],
        isLast: true,
        indicatorStyle: list[2],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          Icons.home,
          size: 35,
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
