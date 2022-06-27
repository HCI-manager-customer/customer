import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FlipStock extends StatefulWidget {
  const FlipStock({Key? key}) : super(key: key);

  @override
  State<FlipStock> createState() => _FlipStockState();
}

class _FlipStockState extends State<FlipStock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: Lottie.asset('assets/json-gif/pacman-loading.json'),
      ),
    );
  }
}
