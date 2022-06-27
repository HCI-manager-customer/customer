import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/screens/prescription/camera_container.dart';
import 'package:image_picker/image_picker.dart';

import 'PresciprtionInfo.dart';

final ImgPath = StateProvider(((ref) => XFile('')));

class PrescriptionScreen extends ConsumerStatefulWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrescriptionScreenState();
}

class _PrescriptionScreenState extends ConsumerState<PrescriptionScreen> {
  String a = 'f';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Prescription'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: const [
                CameraDrug(),
                PrescriptionInfo(),
                Text('We will contact you after we receive the presciption'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
