// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserAction {
  final String userId;
  final String current;
  final String textWith;
  final String pushToken;
  final DateTime createAt;
  final DateTime activeTime;
  UserAction({
    required this.userId,
    required this.current,
    required this.textWith,
    required this.pushToken,
    required this.createAt,
    required this.activeTime,
  });

  UserAction copyWith({
    String? userId,
    String? current,
    String? textWith,
    String? pushToken,
    DateTime? createAt,
    DateTime? activeTime,
  }) {
    return UserAction(
      userId: userId ?? this.userId,
      current: current ?? this.current,
      textWith: textWith ?? this.textWith,
      pushToken: pushToken ?? this.pushToken,
      createAt: createAt ?? this.createAt,
      activeTime: activeTime ?? this.activeTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'current': current,
      'textWith': textWith,
      'pushToken': pushToken,
      'createAt': createAt,
      'activeTime': activeTime,
    };
  }

  factory UserAction.fromMap(Map<String, dynamic> map) {
    return UserAction(
      userId: map['userId'] as String,
      current: map['current'] as String,
      textWith: map['textWith'] as String,
      pushToken: map['pushToken'] as String,
      createAt: (map['createAt'] as Timestamp).toDate(),
      activeTime: (map['activeTime'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAction.fromJson(String source) =>
      UserAction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAction(userId: $userId, current: $current, textWith: $textWith, pushToken: $pushToken, createAt: $createAt, activeTime: $activeTime)';
  }

  @override
  bool operator ==(covariant UserAction other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.current == current &&
        other.textWith == textWith &&
        other.pushToken == pushToken &&
        other.createAt == createAt &&
        other.activeTime == activeTime;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        current.hashCode ^
        textWith.hashCode ^
        pushToken.hashCode ^
        createAt.hashCode ^
        activeTime.hashCode;
  }
}
