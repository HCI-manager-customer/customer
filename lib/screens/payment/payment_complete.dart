import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/main.dart';
import 'package:hci_customer/screens/home/drawer.dart';
import 'package:lottie/lottie.dart';

import '../../icons/my_flutter_app_icons.dart';
import '../../provider/general_provider.dart';

class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen(this.from);
  final String from;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
              'assets/json-gif/check.json',
              height: 400,
              width: 400,
            ),
            ElevatedButton(
              onPressed: () {
                navKey.currentState!.popUntil((route) => route.isFirst);
              },
              child: const Text('Back To Home'),
            ),
            from != 'pre'
                ? Consumer(
                    builder: (_, ref, __) => ElevatedButton(
                      onPressed: () {
                        ref.read(ScreenProvider.notifier).state =
                            const MenuItemDra('My Orders', Icons.shopping_bag);
                        navKey.currentState!.popUntil((route) => route.isFirst);
                      },
                      child: const Text('Check my Order'),
                    ),
                  )
                : Consumer(
                    builder: (_, ref, __) => ElevatedButton(
                      onPressed: () {
                        ref.read(ScreenProvider.notifier).state =
                            const MenuItemDra('My Prescription',
                                MyFlutterApp.prescriptionBottle);
                        navKey.currentState!.popUntil((route) => route.isFirst);
                      },
                      child: const Text('Check my Presription'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
