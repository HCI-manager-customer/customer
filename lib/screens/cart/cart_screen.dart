import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/screens/payment/payment.dart';
import 'package:intl/intl.dart';

import '../../provider/general_provider.dart';
import 'cart_panel.dart';

class CartScreen extends StatelessWidget {
  const CartScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _CartAppBar(context),
      body: Consumer(
        builder: (context, ref, child) {
          var list = ref.watch(cartLProvider);
          return list.isEmpty
              ? const Center(
                  child: Text("Your cart is Empty"),
                )
              : buildCartList(context, ref);
        },
      ),
    );
  }

  AppBar _CartAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text("Your Cart"),
      centerTitle: true,
      backgroundColor: Colors.green,
    );
  }

  Column buildCartList(BuildContext context, WidgetRef ref) {
    double price = 0;
    final list = ref.watch(cartLProvider);
    for (var e in list) {
      price += e.price;
    }
    var formatter = NumberFormat('#,###');
    return Column(
      children: [
        CartPanel(list, true),
        list.isEmpty
            ? Container()
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Total Price: ",
                            style: TextStyle(letterSpacing: 1, fontSize: 18),
                          ),
                          Text(
                            '${formatter.format(price).toString()},000',
                            style: const TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        height: MediaQuery.of(context).size.height * 0.098,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, PaymentScreen.routeName);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
