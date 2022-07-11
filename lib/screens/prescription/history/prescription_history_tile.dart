import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hci_customer/constant/constant.dart';
import 'package:hci_customer/models/drugs.dart';
import 'package:hci_customer/models/prescription.dart';
import 'package:hci_customer/screens/prescription/history/chat/chat_screen.dart';
import 'package:hci_customer/screens/prescription/history/rec_drug_tile.dart';
import 'package:lottie/lottie.dart';

import '../../../models/global.dart';
import '../../../models/note.dart';
import '../../../provider/general_provider.dart';
import '../../cart/cart_panel.dart';
import '../../cart/cart_screen.dart';

class PresciptionHistoryTile extends StatelessWidget {
  const PresciptionHistoryTile(this.preS);
  final Prescription preS;

  @override
  Widget build(BuildContext context) {
    List<String> noList = [];
    String haveMed = '';
    bool isMed = false;
    if (preS.medicines.isEmpty) {
      isMed = false;
      haveMed = 'No Drug';
    } else {
      isMed = true;
      haveMed = 'Check Medicine List';
    }
    List<Note> msg = [];
    if ((preS.note.length > 2)) {
      msg.add(preS.note[preS.note.length - 3]);
      msg.add(preS.note[preS.note.length - 2]);
      msg.add(preS.note[preS.note.length - 1]);
    } else if (preS.note.length > 1) {
      msg.add(preS.note[preS.note.length - 2]);
      msg.add(preS.note[preS.note.length - 1]);
    } else if (preS.note.isNotEmpty) {
      msg.add(preS.note[preS.note.length - 1]);
    } else {
      msg.add(Note(msg: 'No Note', time: DateTime.now()));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: InkWell(
        onTap: () {
          Get.to(() => const ChatScreen());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CachedNetworkImage(
                  height: 200,
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
                title: Text(
                  preS.name,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  preS.status,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                trailing: Consumer(
                  builder: (_, ref, __) => TextButton(
                    onPressed: () {
                      medListHandler(noList, ref, isMed);
                    },
                    child: Text(haveMed),
                  ),
                ),
              ),
              const Divider(),
              if (preS.note.last.msg.startsWith('*/*'))
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Support for this prescription has ended!',
                  ),
                ),
              if (!preS.note.last.msg.startsWith('*/*'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...msg.map((e) => noteText(e)),
                    ],
                  ),
                ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  void medListHandler(List<String> noList, WidgetRef ref, bool isMed) {
    noList.clear();
    if (isMed) {
      Get.defaultDialog(
        title: 'Medicine List',
        content: listDrug(preS.medicines, noList),
        textConfirm: "Create Order",
        textCancel: "Cancel",
        onConfirm: () {
          var currentCart = ref.watch(cartLProvider);
          if (currentCart.isNotEmpty) {
            Get.defaultDialog(
              title: 'Your Current Cart is not Empty',
              content: SizedBox(
                width: Get.width * 0.8,
                height: Get.height * 0.5,
                child: CartPanel(ref.watch(cartLProvider), false),
              ),
              textCancel: 'Cancel',
              textConfirm: 'Clear Cart',
              onConfirm: () {
                ref.read(cartLProvider).clear();
                Get.snackbar('Cart Cleared', 'Your cart is now empty');
                Get.back();
              },
              confirmTextColor: Colors.white,
            );
          } else {
            for (var e in preS.medicines) {
              addorInc(getDrug(e), ref);
            }
            Get.to(() => const CartScreen());
          }
        },
        confirmTextColor: Colors.white,
      );
    } else {
      Get.snackbar(
        'No drugs recommend',
        'You can interact with the doctor in chat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Drug getDrug(String id) {
    final drugs = drugController.drugs;
    for (var i = 0; i < drugs.length; i++) {
      if (drugs[i].id == id) {
        return drugs[i];
      }
    }
    return drugs[0];
  }

  Widget listDrug(List<String> id, List<String> noList) {
    return SizedBox(
      width: Get.width * 0.8,
      height: Get.height * 0.5,
      child: ListView(
        shrinkWrap: true,
        children: id.map((e) {
          if (noList.contains(e)) {
            return Container();
          }
          int count = checkDup(id, e);
          if (count > 1) {
            noList.add(e);
            return RecDrugTile(getDrug(e), count);
          } else {
            return RecDrugTile(getDrug(e), 1);
          }
        }).toList(),
      ),
    );
  }

  int checkDup(List<String> id, String v) {
    int count = 0;
    for (var e in id) {
      if (e == v) {
        count++;
      }
    }
    print('$v : $count');
    return count;
  }

  Widget noteText(Note note) {
    bool isMe = note.msg.startsWith('>');
    String str = '';
    if (note.msg.isEmpty) {
      return Container();
    } else {
      str = note.msg.substring(1);
      if (isMe) {
        str = 'You: $str';
      } else {
        str = '$str :CS';
      }
      return Align(
        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Text(
          str,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
  }
}
