import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/note.dart';

class ChatPanel extends StatelessWidget {
  const ChatPanel(this.roomId);
  final String roomId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('prescription')
          .doc(roomId)
          .collection('note')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(
            child: Lottie.asset('assets/animations/loading.json'),
          );
        } else {
          final List<Note> notes =
              snapshot.data!.docs.map((e) => Note.fromMap(e.data())).toList();

          return _buildChat(notes);
        }
      },
    );
  }

  Widget _buildChat(List<Note> notes) {
    String mail = FirebaseAuth.instance.currentUser!.email.toString();
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        bool isSender = note.mail == mail;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: note.mail == name ? Colors.blue : Colors.green,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BubbleSpecialThree(
              text: note.msg.substring(0),
              isSender: isSender,
              color: isSender ? const Color(0xFFE8E8EE) : Colors.green,
            ),
          ),
        );
      },
    );
  }
}
