import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

const bool USE_EMULATOR = false;

class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('hi').add({
                    'demo': true,
                  });
                },
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: 'test@test.com', password: '123456');
                },
                child: const Text('create'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: 'test@test.com', password: '123456');
                  var a = await FirebaseMessaging.instance.getToken();
                  print(a);
                },
                child: const Text('get token'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final db = FirebaseFirestore.instance.collection('hi');
                  await db.get().then(
                        (value) => value.docs.forEach(
                          (e) async {
                            if (e.data()['demo'] == true) {
                              await db.doc(e.id).update(
                                {'demo': false},
                              );
                            } else {
                              print('set to true');
                              await db.doc(e.id).update(
                                {'demo': true},
                              );
                            }
                          },
                        ),
                      );
                },
                child: const Text('update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
