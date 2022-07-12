// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Prescription {
  String id;
  String mail;
  String name;
  String addr;
  String imgurl;
  String status;
  List<String> medicines;
  DateTime createAt;
  Prescription({
    required this.id,
    required this.mail,
    required this.name,
    required this.addr,
    required this.imgurl,
    required this.status,
    required this.medicines,
    required this.createAt,
  });

  Prescription copyWith({
    String? id,
    String? mail,
    String? name,
    String? addr,
    String? imgurl,
    String? status,
    List<String>? medicines,
    DateTime? createAt,
  }) {
    return Prescription(
      id: id ?? this.id,
      mail: mail ?? this.mail,
      name: name ?? this.name,
      addr: addr ?? this.addr,
      imgurl: imgurl ?? this.imgurl,
      status: status ?? this.status,
      medicines: medicines ?? this.medicines,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'mail': mail,
      'name': name,
      'addr': addr,
      'imgurl': imgurl,
      'status': status,
      'medicines': medicines,
      'createAt': createAt.millisecondsSinceEpoch,
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'] as String,
      mail: map['mail'] as String,
      name: map['name'] as String,
      addr: map['addr'] as String,
      imgurl: map['imgurl'] as String,
      status: map['status'] as String,
      medicines: List<String>.from(
        (map['medicines'] as List<dynamic>),
      ),
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Prescription.fromJson(String source) =>
      Prescription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Prescription(id: $id, mail: $mail, name: $name, addr: $addr, imgurl: $imgurl, status: $status, medicines: $medicines, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant Prescription other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.mail == mail &&
        other.name == name &&
        other.addr == addr &&
        other.imgurl == imgurl &&
        other.status == status &&
        listEquals(other.medicines, medicines) &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        mail.hashCode ^
        name.hashCode ^
        addr.hashCode ^
        imgurl.hashCode ^
        status.hashCode ^
        medicines.hashCode ^
        createAt.hashCode;
  }
}

Prescription dummyPres = Prescription(
    createAt: DateTime.now(),
    id: '',
    mail: '',
    name: '',
    addr: '',
    imgurl: '',
    status: '',
    medicines: []);
