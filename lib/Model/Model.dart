// To parse this JSON data, do
//
//     final fakeStore = fakeStoreFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<FakeStore> fakeStoreFromJson(String str) => List<FakeStore>.from(json.decode(str).map((x) => FakeStore.fromJson(x)));

String fakeStoreToJson(List<FakeStore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FakeStore {
  int id;
  String title;
  double price;
  String description;
  String image;
  bool favorite;

  FakeStore({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    this.favorite = false,
  });

  factory FakeStore.fromJson(Map<String, dynamic> json) => FakeStore(
    id: json["id"],
    title: json["title"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    image: json["image"],
    favorite: false, 
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "image": image,
    "favorite" :favorite
  };
}