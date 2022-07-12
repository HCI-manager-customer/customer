import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../models/user_action.dart';

class UserActionoController extends GetxController {
  static UserActionoController instance = Get.find();

  Rx<UserAction> userAction = Rx<UserAction>(UserAction(
    userId: '',
    createAt: DateTime.now(),
    current: '',
    pushToken: '',
    textWith: '',
    activeTime: DateTime.now(),
  ));

  UserAction get getUserAction => userAction.value;

  set setUserAction(UserAction uA) {
    userAction.value = uA;
  }

  @override
  void onInit() async {
    super.onInit();
    try {
      final token = await FirebaseMessaging.instance.getToken();
      // String token = notifiController.pushToken.value;
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      setUserAction = getUserAction.copyWith(
        current: 'logged in',
        textWith: '',
        pushToken: token.toString(),
        userId: firebaseUser.email,
      );
      sendUser(getUserAction);
    } catch (e) {
      log(e.toString());
    }
  }

  Future sendUser(UserAction u) async {
    try {
      final db = FirebaseFirestore.instance.collection('UserActivity');
      final docRef = db.doc(u.userId);
      await docRef.set(u.toMap());
      final updates = <String, dynamic>{
        "activeTime": FieldValue.serverTimestamp(),
        "createAt": FieldValue.serverTimestamp(),
      };
      docRef.update(updates);
    } catch (e) {
      log(e.toString());
    }
  }

  Future updateUser(UserAction u) async {
    final db = FirebaseFirestore.instance.collection('UserActivity');
    final docRef = db.doc(u.userId);
    await docRef.set(u.toMap());
    final updates = <String, dynamic>{
      "activeTime": FieldValue.serverTimestamp(),
    };
    docRef.update(updates);
  }

  void setAction(String action) {
    setUserAction = getUserAction.copyWith(current: action);
  }
}
