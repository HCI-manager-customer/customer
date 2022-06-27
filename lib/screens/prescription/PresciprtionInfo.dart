import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hci_customer/models/global.dart';
import 'package:hci_customer/models/prescription.dart';
import 'package:hci_customer/provider/general_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../payment/payment_complete.dart';
import 'presciption_screen.dart';

class PrescriptionInfo extends ConsumerStatefulWidget {
  const PrescriptionInfo();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrescriptionInfoState();
}

class _PrescriptionInfoState extends ConsumerState<PrescriptionInfo> {
  final nameCtl = TextEditingController();
  final addrCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String mail = '';

  @override
  void initState() {
    nameCtl.text = '';
    addrCtl.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, child) {
                return Column(
                  children: [
                    Text(
                      ref.watch(UserProvider).currentUser!.displayName ?? '',
                      style: const TextStyle(fontSize: 20, letterSpacing: 1),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      mail = ref.watch(UserProvider).currentUser!.email ?? '',
                      style: const TextStyle(fontSize: 20, letterSpacing: 1),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameCtl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Patient Name';
                }
                return null;
              },
              decoration: const InputDecoration(hintText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: addrCtl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Address';
                }
                return null;
              },
              decoration: const InputDecoration(hintText: 'Address'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    uploadImg();
                  }
                },
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future uploadImg() async {
    SendPresciprClass(ref.watch(ImgPath)).myAsyncMethod(context, (value) {
      final prescrip = Prescription(
        name: nameCtl.text,
        addr: addrCtl.text,
        mail: FirebaseAuth.instance.currentUser!.email.toString(),
        Imgurl: value,
      );
      if (!mounted) return;
      if (value.length > 10) {
        uploadPrescipInfo(prescrip);
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentCompleteScreen(),
          ),
        );
        ref.invalidate(ImgPath);
      }
    });
  }

  Future<void> uploadPrescipInfo(Prescription prescrip) async {
    await db.collection('prescription').add(prescrip.toMap());
  }
}

class SendPresciprClass {
  SendPresciprClass(this.xfile);

  final XFile? xfile;

  Future<void> myAsyncMethod(BuildContext context, Function onSuccess) async {
    UploadTask? uploadTask;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  Text("Loading"),
                ],
              ),
            ),
          );
        },
      );
      final file = File(xfile!.path);
      final path = 'prescription/${xfile!.name}';

      final send = FirebaseStorage.instance.ref().child(path);
      uploadTask = send.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      String url = await snapshot.ref.getDownloadURL();
      onSuccess(url);
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
              child: const Text('OK'),
            )
          ],
          content: const Text('Please select or take the Drug\'s Presription'),
          title: const Text('Warning'),
        ),
      );
    }
  }
}
