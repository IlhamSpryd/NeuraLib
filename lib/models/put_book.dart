// To parse this JSON data, do
//
//     final putBook = putBookFromJson(jsonString);

import 'dart:convert';

PutBook putBookFromJson(String str) => PutBook.fromJson(json.decode(str));

String putBookToJson(PutBook data) => json.encode(data.toJson());

class PutBook {
  String? message;
  dynamic data;

  PutBook({this.message, this.data});

  factory PutBook.fromJson(Map<String, dynamic> json) =>
      PutBook(message: json["message"], data: json["data"]);

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}
