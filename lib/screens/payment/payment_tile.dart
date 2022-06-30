import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/general_provider.dart';

class PaymentTile extends ConsumerWidget {
  const PaymentTile(this.i);
  final int i;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(cartLProvider);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      leading: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Image.network(
          list[i].drug.imgUrl,
          cacheHeight: 500,
        ),
      ),
      title: Text(
        list[i].drug.fullName,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: const TextStyle(letterSpacing: 1, fontSize: 15),
      ),
      subtitle: Text(
          '${list[i].price.toStringAsFixed(3)} - ${list[i].quantity} ${list[i].drug.unit}'),
      trailing: IconButton(
        onPressed: () {
          ref.read(cartLProvider.notifier).removeCartAt(list[i]);
          if (ref.watch(cartLProvider).isEmpty) {
            Navigator.pop(context, true);
          }
        },
        icon: const Icon(
          Icons.remove_circle,
          color: Colors.red,
        ),
      ),
    );
  }
}
