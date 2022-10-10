//pembuatan sebuah class Product yang nantinya akan digunakan pada fitur purchase planning
class Product {
   //deklarasi masing-masing variabel
  int _id;
  String _name;
  int _quantity;
  int _price;

  //pembuatan getter setter

  int get id => _id;

  String get name => this._name;
  set name(String value) => this._name = value;

  get quantity => this._quantity;
  set quantity(value) => this._quantity = value;

  get price => this._price;
  set price(value) => this._price = value;

  // konstruktor versi 1
  Product(this._name, this._quantity, this._price);

  // konstruktor versi 2: konversi dari Map ke Item
  Product.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._quantity = map['quantity'];
    this._price = map['price'];
  }

  // konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['quantity'] = quantity;
    map['price'] = price;
    return map;
  }
}
