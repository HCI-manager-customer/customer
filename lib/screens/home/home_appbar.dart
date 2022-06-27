import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../cart/cart_screen.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => ZoomDrawer.of(context)!.toggle(),
        icon: const Icon(Icons.menu_rounded),
      ),
      title: const Text("Pharmacy"),
      centerTitle: true,
      backgroundColor: Colors.green,
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
