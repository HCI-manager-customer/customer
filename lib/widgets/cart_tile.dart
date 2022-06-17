import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/addons/responsive.dart';

import '../provider/general_provider.dart';
import '../screens/info.dart';
import 'flip_stock.dart';

class CartTile extends ConsumerWidget {
  CartTile(this.index);

  final int index;

  var countController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cart = ref.watch(cartLProvider).elementAt(index);

    countController.text =
        ref.watch(cartLProvider).elementAt(index).quantity.toString();
    Size size = MediaQuery.of(context).size;
    final imgHei = Responsive.isDesktop(context)
        ? 120
        : Responsive.isTablet(context)
            ? 80
            : size.height * 0.1;
    final imgWid = Responsive.isDesktop(context)
        ? 200
        : Responsive.isTablet(context)
            ? 150
            : size.width * 0.4;
    return Container(
        height: size.height * 0.2,
        width: size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => InfoScreen(cart.drug)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: Image.network(
                      height: imgHei.toDouble(),
                      width: imgWid.toDouble(),
                      cart.drug.imgUrl,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: FlipStock(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Text(
                      cart.drug.fullName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 16, letterSpacing: 1.0),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: " ${cart.drug.rating.toStringAsFixed(1)}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          ref.read(cartLProvider.notifier).inQuan(index);
                        },
                        icon: const Icon(
                          Icons.add_circle_outlined,
                          color: Colors.green,
                        )),
                    Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: TextField(
                        onSubmitted: (value) {
                          ref
                              .read(cartLProvider.notifier)
                              .setQuan(index, int.parse(value));
                        },
                        textAlign: TextAlign.center,
                        controller: countController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () =>
                            ref.read(cartLProvider.notifier).deQuan(index),
                        icon: const Icon(
                          Icons.remove_circle_outlined,
                          color: Colors.green,
                        )),
                  ],
                ),
                Text(
                  cart.drug.unit,
                  style: const TextStyle(fontSize: 13, letterSpacing: 1),
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  'Total: ${ref.watch(cartLProvider).elementAt(index).price.toStringAsFixed(3)}',
                  style: const TextStyle(fontSize: 15, letterSpacing: 1),
                ),
              ],
            ),
            const Divider()
          ],
        ));
  }
}
