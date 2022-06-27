import 'package:flutter/material.dart';

class NearbyStoreScreen extends StatelessWidget {
  const NearbyStoreScreen({Key? key}) : super(key: key);

  static const routeName = '/nearby';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Nearby Store'),
        ),
        body: Center(
          child: Image.asset('assets/imgs/nearby.PNG'),
        ));
  }
}
