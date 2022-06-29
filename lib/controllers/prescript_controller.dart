import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/prescription.dart';

class PreScripController extends GetxController {
  static PreScripController instance = Get.find();
  Rx<List<Prescription>> prescList = Rx<List<Prescription>>([]);

  List<Prescription> get prescription => prescList.value;

  @override
  void onInit() {
    prescList.bindStream(PrescriptionSerivce().preScriptStream());
    super.onInit();
  }
}

class PrescriptionSerivce {
  final CollectionReference _prescription =
      FirebaseFirestore.instance.collection('prescription');

  Stream<List<Prescription>> preScriptStream() {
    print('stream mail: ${FirebaseAuth.instance.currentUser!.email}');
    return _prescription
        .where('mail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final f = Prescription.fromMap(doc.data() as dynamic);
              return f;
            }).toList());
  }
}
