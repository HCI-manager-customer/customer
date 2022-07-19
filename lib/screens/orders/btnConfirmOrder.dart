import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hci_customer/models/order.dart';
import 'package:hci_customer/screens/payment/payment.dart';

import '../../models/global.dart';
import '../../provider/general_provider.dart';
import '../payment/payment_complete.dart';

class BtnConfirmOrder extends ConsumerWidget {
  const BtnConfirmOrder(this.method, this.price);

  final double price;
  final String method;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnable = ref.watch(isFilledProvider);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          onPressed: isEnable
              ? () {
                  var list = ref.watch(cartLProvider);
                  final u = ref.watch(UserProvider).currentUser!;
                  final user = ref.watch(pharmacyUserProvider);

                  Order order = Order(
                    id: '',
                    user: user,
                    method: method,
                    listCart: list,
                    price: price,
                    status: 'NewOrder',
                    date: DateTime.now(),
                  );
                  sendOrder(order);
                  updateUser(user);
                  ref.read(cartLProvider.notifier).wipe();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PaymentCompleteScreen('payment'),
                    ),
                  );
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                isEnable ? Colors.green : Colors.red.shade400),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          child: Text(
            isEnable
                ? "Confirm Order: ${formatter.format(price).toString()},000"
                : 'Please Fill your Delivery Info',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
