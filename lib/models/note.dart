// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String msg;
  DateTime time;
  Note({
    required this.msg,
    required this.time,
  });

  Note copyWith({
    String? msg,
    DateTime? time,
  }) {
    return Note(
      msg: msg ?? this.msg,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'time': time,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      msg: map['msg'] as String,
      time: (map['time'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Note(msg: $msg, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note && other.msg == msg && other.time == time;
  }

  @override
  int get hashCode => msg.hashCode ^ time.hashCode;
}
