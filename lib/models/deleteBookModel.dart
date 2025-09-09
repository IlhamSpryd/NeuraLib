// To parse this JSON data, do
//
//     final deleteBook = deleteBookFromJson(jsonString);

import 'dart:convert';

DeleteBook deleteBookFromJson(String str) =>
    DeleteBook.fromJson(json.decode(str));

String deleteBookToJson(DeleteBook data) => json.encode(data.toJson());

class DeleteBook {
  String? message;
  dynamic data;

  DeleteBook({this.message, this.data});

  factory DeleteBook.fromJson(Map<String, dynamic> json) =>
      DeleteBook(message: json["message"], data: json["data"]);

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}
