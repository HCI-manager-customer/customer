import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/global.dart';
import 'package:hci_customer/models/note.dart';
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
  final noteCtl = TextEditingController();
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
            Consumer(
              builder: (context, ref, child) {
                return Text(
                  'Sender: ${ref.watch(UserProvider).currentUser!.displayName ?? ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 20, letterSpacing: 1),
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
            const SizedBox(height: 20),
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
            TextFormField(
              controller: noteCtl,
              decoration: const InputDecoration(
                  hintText: 'Any note for us? (optional)'),
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
    String name = FirebaseAuth.instance.currentUser!.displayName.toString();
    String mail = FirebaseAuth.instance.currentUser!.email.toString();
    SendPresciprClass(ref.watch(ImgPath)).myAsyncMethod(context, (value) {
      Note note = Note(
        msg: '>Posted a Drug Prescription',
        time: DateTime.now(),
        mail: mail,
        name: name,
      );
      if (noteCtl.text.isNotEmpty) {
        note.msg = '>${noteCtl.text}';
      }
      final prescrip = Prescription(
        id: '1',
        name: nameCtl.text,
        addr: addrCtl.text,
        mail: FirebaseAuth.instance.currentUser!.email.toString(),
        imgurl: value,
        medicines: [],
        status: 'pending',
        createAt: DateTime.now(),
      );

      if (!mounted) return;
      if (value.length > 10) {
        uploadPrescipInfo(prescrip);
        Get.back();
        Get.to(() => const PaymentCompleteScreen('pre'));
        ref.invalidate(ImgPath);
      }
    });
  }

  Future<void> uploadPrescipInfo(Prescription prescrip) async {
    await db.collection('prescription').add(prescrip.toMap()).then((value) {
      prescrip.id = value.id;
      db.collection('prescription').doc(value.id).update(prescrip.toMap());
    });
    Note note = Note(
        name: FirebaseAuth.instance.currentUser!.displayName.toString(),
        msg: 'Posted a Drug Prescription',
        time: DateTime.now(),
        mail: FirebaseAuth.instance.currentUser!.email.toString());
    await db.collection('prescription').doc(prescrip.id).collection('note').add(
          note.toMap(),
        );
  }
}

class SendPresciprClass {
  SendPresciprClass(this.xfile);

  final XFile? xfile;

  Future<void> myAsyncMethod(BuildContext context, Function onSuccess) async {
    UploadTask? uploadTask;
    try {
      Get.defaultDialog(
        title: "Uploading, Please wait...",
        content: const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
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
