import 'package:flutter/cupertino.dart';

//pembuatan sebuah class Calculate yang nantinya akan digunakan pada fitur calculating transaction
class Calculate {
  //deklarasi masing-masing variabel
 final String id; 
  final String name;
  final int price;
  final int quantity;

//konstruktor 
Calculate({
    @required this.id,
    @required this.name,
    @required this.quantity,
    @required this.price,
  });
}
