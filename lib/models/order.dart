// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:hci_customer/models/user.dart';

import 'cart.dart';

class Order {
  String id;
  PharmacyUser user;
  List<Cart> listCart;
  num price;
  String method;
  String status;
  DateTime date;
  Order({
    required this.id,
    required this.user,
    required this.listCart,
    required this.price,
    required this.method,
    required this.status,
    required this.date,
  });

  Order copyWith({
    String? id,
    PharmacyUser? user,
    List<Cart>? listCart,
    num? price,
    String? method,
    String? status,
    DateTime? date,
  }) {
    return Order(
      id: id ?? this.id,
      user: user ?? this.user,
      listCart: listCart ?? this.listCart,
      price: price ?? this.price,
      method: method ?? this.method,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'listCart': listCart.map((x) => x.toMap()).toList(),
      'price': price,
      'method': method,
      'status': status,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      user: PharmacyUser.fromMap(map['user'] as Map<String, dynamic>),
      listCart: List<Cart>.from(
        (map['listCart'] as List<dynamic>).map<Cart>(
          (x) => Cart.fromMap(x as Map<String, dynamic>),
        ),
      ),
      price: map['price'] as num,
      method: map['method'] as String,
      status: map['status'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, user: $user, listCart: $listCart, price: $price, method: $method, status: $status, date: $date)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        listEquals(other.listCart, listCart) &&
        other.price == price &&
        other.method == method &&
        other.status == status &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        listCart.hashCode ^
        price.hashCode ^
        method.hashCode ^
        status.hashCode ^
        date.hashCode;
  }
}
