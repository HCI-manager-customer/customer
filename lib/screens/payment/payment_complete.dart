import 'package:flutter/material.dart';
import 'package:hci_customer/main.dart';
import 'package:lottie/lottie.dart';

class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({Key? key}) : super(key: key);

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
        children: [
          Lottie.asset(
            'assets/json-gif/check.json',
            height: 200,
            width: 200,
          ),
          ElevatedButton(
              onPressed: () {
                navKey.currentState!.popUntil((route) => route.isFirst);
              },
              child: const Text('Back To Home'))
        ],
      )),
    );
  }
}
