import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/global.dart';
import 'package:hci_customer/models/prescription.dart';

import '../../../../controllers/notification_controller.dart';
import 'chat_panel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(this.id, this.isEnd);

  final String id;
  final bool isEnd;

  @override
  Widget build(BuildContext context) {
    var textCtl = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'End your chat with CS?',
                  content:
                      const Text('Are you sure you want to end your chat?'),
                  textCancel: 'Cancel',
                  textConfirm: 'End',
                  onConfirm: () {
                    endChat(id);
                    Get.back();
                    Get.back();
                  },
                );
              },
              icon: const Icon(Icons.done_all))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatPanel(id)),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('prescription')
                .doc(id)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const Center(
                  child: Text('Getting Room Information'),
                );
              } else {
                final data = Prescription.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>);
                bool isSupport = data.status == 'FINISH';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(), color: Colors.white38),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            NotificationController().showNotification(
                                2, 'title', 'BODY BODY', 'main');
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.end,
                            enabled: !isSupport,
                            controller: textCtl,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 10),
                              hintText: isSupport
                                  ? 'Support has ended'
                                  : 'Type your message here',
                            ),
                            maxLength: 250,
                            maxLines: null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send,
                              color: Colors.blue, size: 30),
                          onPressed: () {
                            if (isSupport) {
                              Get.snackbar('You can not send message',
                                  'This Presciption support has ended',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            } else if (textCtl.text.trim().isEmpty) {
                              Get.snackbar('Type Something',
                                  'You need to type something in chat',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            } else {
                              sendMsgChat(id, textCtl.text.trim());
                              textCtl.clear();
                            }
                          },
                        )
                      ]),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
