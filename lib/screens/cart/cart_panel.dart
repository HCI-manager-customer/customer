import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../models/cart.dart';
import '../../provider/general_provider.dart';
import '../prescription/history/crCartTile.dart';
import 'cart_tile.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel(this.list, this.isCartView);

  final List<Cart> list;
  final bool isCartView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: Get.height * 0.75,
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final drug = list[i].drug;
            return AnimationConfiguration.staggeredGrid(
              position: i,
              columnCount: list.length,
              duration: const Duration(milliseconds: 1000),
              child: ScaleAnimation(
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          ref
                              .read(cartLProvider.notifier)
                              .removeCartAt(list[i]);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remove',
                      )
                    ],
                  ),
                  child: isCartView ? CartTile(i) : CurrentCartTile(drug),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
