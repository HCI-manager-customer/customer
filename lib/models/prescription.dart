// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:hci_customer/models/note.dart';

class Prescription {
  String idChat;
  String mail;
  String name;
  String addr;
  String Imgurl;
  String status;
  List<String> medicines;
  List<Note> note;
  Prescription({
    required this.idChat,
    required this.mail,
    required this.name,
    required this.addr,
    required this.Imgurl,
    required this.status,
    required this.medicines,
    required this.note,
  });

  Prescription copyWith({
    String? idChat,
    String? mail,
    String? name,
    String? addr,
    String? Imgurl,
    String? status,
    List<String>? medicines,
    List<Note>? note,
  }) {
    return Prescription(
      idChat: idChat ?? this.idChat,
      mail: mail ?? this.mail,
      name: name ?? this.name,
      addr: addr ?? this.addr,
      Imgurl: Imgurl ?? this.Imgurl,
      status: status ?? this.status,
      medicines: medicines ?? this.medicines,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idChat': idChat,
      'mail': mail,
      'name': name,
      'addr': addr,
      'Imgurl': Imgurl,
      'status': status,
      'medicines': medicines,
      'note': note.map((x) => x.toMap()).toList(),
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      idChat: map['idChat'] as String,
      mail: map['mail'] as String,
      name: map['name'] as String,
      addr: map['addr'] as String,
      Imgurl: map['Imgurl'] as String,
      status: map['status'] as String,
      medicines: List<String>.from(
        (map['medicines'] as List<dynamic>),
      ),
      note: List<Note>.from(
        (map['note'] as List<dynamic>).map<Note>(
          (x) => Note.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Prescription.fromJson(String source) =>
      Prescription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Prescription(idChat: $idChat, mail: $mail, name: $name, addr: $addr, Imgurl: $Imgurl, status: $status, medicines: $medicines, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prescription &&
        other.idChat == idChat &&
        other.mail == mail &&
        other.name == name &&
        other.addr == addr &&
        other.Imgurl == Imgurl &&
        other.status == status &&
        listEquals(other.medicines, medicines) &&
        listEquals(other.note, note);
  }

  @override
  int get hashCode {
    return idChat.hashCode ^
        mail.hashCode ^
        name.hashCode ^
        addr.hashCode ^
        Imgurl.hashCode ^
        status.hashCode ^
        medicines.hashCode ^
        note.hashCode;
  }
}
