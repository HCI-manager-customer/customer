import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/note.dart';
import 'package:hci_customer/models/user.dart';
import 'package:intl/intl.dart';

import '../provider/general_provider.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/prescription/presciption_screen.dart';
import 'cart.dart';
import 'drugs.dart';
import 'order.dart';

var formatter = NumberFormat('###,###');
final db = FirebaseFirestore.instance;

void addorInc(Drug drug, WidgetRef ref) {
  final list = ref.watch(cartLProvider);
  Get.closeAllSnackbars();
  if (list.isEmpty) {
    list.add(Cart(drug: drug, quantity: 1, price: drug.price));
  } else if (list.isNotEmpty) {
    for (var e in list) {
      if (e.drug.id == drug.id) {
        e.quantity++;
        e.price = e.quantity * e.drug.price;
        return;
      }
    }
    ref
        .read(cartLProvider.notifier)
        .add(Cart(drug: drug, quantity: 1, price: drug.price));
  }
}

void sendOrder(Order order) async {
  await db.collection('orders').add(order.toMap()).then((value) {
    order.id = value.id;
    db.collection('orders').doc(value.id).update(order.toMap());
  });
}

void updateUser(PharmacyUser u) async {
  await db
      .collection('users')
      .doc(u.mail)
      .update({'addr': u.addr, 'phone': u.phone});
}

void showAddedMsg(BuildContext context, Drug drug, WidgetRef ref) {
  addorInc(drug, ref);
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: 'To my Cart',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Get.to(() => const CartScreen());
        },
        textColor: Colors.cyanAccent,
      ),
      content: SafeArea(
        child: Row(
          children: const [
            Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 15),
            Text("Item added to cart"),
          ],
        ),
      ),
      backgroundColor: Colors.green,
    ),
  );
}

Future sendMsgChat(String idChat, String msg) async {
  try {
    Note note = Note(
      patient: FirebaseAuth.instance.currentUser!.email.toString(),
      msg: msg,
      time: DateTime.now(),
      mail: FirebaseAuth.instance.currentUser!.email.toString(),
      name: FirebaseAuth.instance.currentUser!.displayName.toString(),
    );
    await FirebaseFirestore.instance
        .collection('prescription')
        .doc(idChat)
        .collection('note')
        .add(
          note.toMap(),
        );
  } on Exception catch (e) {
    print(e);
  }
}

void endChat(String idChat) {
  try {
    sendMsgChat(idChat,
        "*/*Ended by ${FirebaseAuth.instance.currentUser!.displayName} at ${DateTime.now()}");
    FirebaseFirestore.instance.collection('prescription').doc(idChat).update({
      "status":
          "Ended by ${FirebaseAuth.instance.currentUser!.displayName} at ${DateTime.now()}",
    });
  } on Exception catch (e) {
    print(e);
  }
}

void wipeData(WidgetRef ref) {
  ref.invalidate(cartLProvider);
  ref.invalidate(googleSignInProvider);
  ref.invalidate(UserProvider);
  ref.invalidate(ScreenProvider);
  ref.invalidate(pharmacyUserProvider);
  ref.invalidate(ImgPath);
}
