// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:hci_customer/controllers/user_action_controller.dart';
import 'package:hci_customer/models/global.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/prescript_controller.dart';
import '../../icons/my_flutter_app_icons.dart';
import '../../main.dart';
import '../../provider/general_provider.dart';

class MenuItemDra {
  final String title;
  final IconData icon;
  const MenuItemDra(this.title, this.icon);
}

class MenuItems {
  static const home = MenuItemDra('Home', Icons.home);
  static const orders = MenuItemDra('My Orders', Icons.shopping_bag);
  static const prescrip =
      MenuItemDra('My Prescription', MyFlutterApp.prescriptionBottle);
  static const about =
      MenuItemDra('Heart Rate Monitor', Icons.monitor_heart_sharp);

  static const all = <MenuItemDra>[home, orders, prescrip, about];
}

class DrawerScreen extends ConsumerWidget {
  const DrawerScreen(this._drawerController);

  final ZoomDrawerController _drawerController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(UserProvider).currentUser;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CircleAvatar(
                radius: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: CachedNetworkImage(
                    height: 500,
                    fit: BoxFit.cover,
                    memCacheHeight: 500,
                    imageUrl: user!.photoURL.toString(),
                    placeholder: (_, url) => Lottie.asset(
                      'assets/json-gif/image-loading.json',
                      height: 500,
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                    ),
                    errorWidget: (_, url, er) => Lottie.asset(
                      'assets/json-gif/image-loading.json',
                      alignment: Alignment.center,
                      height: 500,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Center(child: Consumer(
                builder: (context, ref, child) {
                  return Text(
                    user.displayName.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 25),
                  );
                },
              )),
            ),
            const Spacer(flex: 1),
            ...MenuItems.all
                .map((e) => BuildMenuItem(e, _drawerController))
                .toList(),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Consumer(
                builder: (context, ref, child) {
                  return ListTile(
                    onTap: () async {
                      if (!kIsWeb) {
                        ref.watch(googleSignInProvider).signOut();
                      }
                      await Get.delete<UserActionoController>();
                      await Get.delete<OrderController>();
                      await Get.delete<PreScripController>();
                      await FirebaseAuth.instance.signOut();
                      wipeData(ref);
                      navKey.currentState!.popUntil((route) => route.isFirst);
                    },
                    minLeadingWidth: 20,
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                  );
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}

class BuildMenuItem extends ConsumerWidget {
  const BuildMenuItem(this.item, this._drawerController);
  final MenuItemDra item;
  final ZoomDrawerController _drawerController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentItem = ref.watch(ScreenProvider);
    return ListTile(
      selected: currentItem == item,
      selectedTileColor: Colors.white,
      minLeadingWidth: 20,
      leading: Icon(item.icon),
      title: Text(item.title),
      onTap: () {
        ref.read(ScreenProvider.notifier).state = item;
        Timer(const Duration(milliseconds: 50), () {
          _drawerController.close!();
        });
      },
    );
  }
}
