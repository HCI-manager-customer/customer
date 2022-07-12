// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String msg;
  DateTime time;
  String mail;
  String name;
  Note({
    required this.msg,
    required this.time,
    required this.mail,
    required this.name,
  });

  Note copyWith({
    String? msg,
    DateTime? time,
    String? mail,
    String? name,
  }) {
    return Note(
      msg: msg ?? this.msg,
      time: time ?? this.time,
      mail: mail ?? this.mail,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'time': time,
      'mail': mail,
      'name': name,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      msg: map['msg'] as String,
      time: (map['time'] as Timestamp).toDate(),
      mail: map['mail'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Note(msg: $msg, time: $time, mail: $mail, name: $name)';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;

    return other.msg == msg &&
        other.time == time &&
        other.mail == mail &&
        other.name == name;
  }

  @override
  int get hashCode {
    return msg.hashCode ^ time.hashCode ^ mail.hashCode ^ name.hashCode;
  }
}
