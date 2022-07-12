import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hci_customer/screens/heart_rate/hear_screen.dart';
import 'package:hci_customer/screens/home/drawer.dart';
import 'package:hci_customer/screens/orders/history/order_history.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/prescript_controller.dart';
import '../../provider/general_provider.dart';
import 'home.dart';
import '../prescription/history/prescription_histoy.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer();

  static const routeName = '/home_drawer';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  final _drawerController = ZoomDrawerController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(UserProvider.state).state = FirebaseAuth.instance;
    });
  }

  int backPressCounter = 0;
  int backPressTotal = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: WillPopScope(
        onWillPop: () async {
          if (backPressCounter < 1) {
            Fluttertoast.showToast(
                msg:
                    "Press ${backPressTotal - backPressCounter} time to exit app");
            backPressCounter++;
            Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
              backPressCounter--;
            });
            return Future.value(false);
          } else {
            SystemNavigator.pop();
            return Future.value(true);
          }
        },
        child: ZoomDrawer(
          slideWidth: MediaQuery.of(context).size.width * 0.7,
          controller: _drawerController,
          borderRadius: 24.0,
          showShadow: true,
          mainScreenTapClose: true,
          androidCloseOnBackTap: true,
          drawerShadowsBackgroundColor: Colors.teal,
          openCurve: Curves.fastOutSlowIn,
          mainScreen: getScreen(),
          menuScreen: DrawerScreen(_drawerController),
        ),
      ),
    );
  }

  Widget getScreen() {
    final currentScreen = ref.watch(ScreenProvider);
    switch (currentScreen) {
      case MenuItems.home:
        return const HomeScreen();
      case MenuItems.about:
        return const HeartRateScreen();
      case MenuItems.orders:
        return const OrderHistoryScreen();
      case MenuItems.prescrip:
        return const PresciptionHistoryScreen();
      default:
        return const HomeScreen();
    }
  }
}
