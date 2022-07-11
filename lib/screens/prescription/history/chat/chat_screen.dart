import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hci_customer/models/global.dart';

import 'chat_panel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(this.idChat, this.isEnd);

  final String idChat;
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
                    endChat(idChat);
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
          Expanded(child: ChatPanel(idChat)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration:
                BoxDecoration(border: Border.all(), color: Colors.white38),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    enabled: !isEnd,
                    controller: textCtl,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10),
                      hintText: 'Type your message here',
                    ),
                    maxLength: 250,
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue, size: 30),
                  onPressed: () {
                    if (isEnd) {
                      Get.snackbar('You can not send message',
                          'This Presciption support has ended',
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } else if (textCtl.text.trim().isEmpty) {
                      Get.snackbar('Type Something',
                          'You need to type something in chat',
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } else {
                      sendMsgChat(idChat, '>${textCtl.text}'.trim());
                      textCtl.clear();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
