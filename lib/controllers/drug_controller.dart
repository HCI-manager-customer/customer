import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/drugs.dart';

class DrugController extends GetxController {
  static DrugController instance = Get.find();
  Rx<List<Drug>> drugList = Rx<List<Drug>>([]);

  List<Drug> get drugs => drugList.value;

  @override
  void onInit() {
    drugList.bindStream(DrugService().drugStream());
    super.onInit();
  }
}

class DrugService {
  final CollectionReference _drug =
      FirebaseFirestore.instance.collection('drugs');

  Stream<List<Drug>> drugStream() {
    return _drug.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final f = Drug.fromMap(doc.data() as dynamic);
          return f;
        }).toList());
  }
}
