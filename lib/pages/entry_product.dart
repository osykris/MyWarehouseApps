import 'package:flutter/material.dart';
import 'package:uts_osy/db_helper.dart';
import 'package:uts_osy/models/product.dart';

class Entry_Product extends StatefulWidget {  // pembuatan class Entry_Product yang memperluaskan statefullwidget
  final Product product; // objek product dari Class Product bertype final
  Entry_Product(this.product); //konstruktor yang menerima parameter product
  @override
  Entry_ProductState createState() => Entry_ProductState(this.product);
}

//class controller
class Entry_ProductState extends State<Entry_Product> {

  DbHelper dbHelper = DbHelper(); //pembuatan obejk dbHelper dari class DBHelper
  Product product; //objek product dari class Product
  Entry_ProductState(this.product); //konstruktor yang menerima parameter product

  //pembuatan text editing controller
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //kondisi
    bool check = false; // variabel check dengan type boolean yang menampung nilai false
    //kondisi jika entry null
    if (product != null) {
      //variabel dari objek product akan merima inputan dari user
      nameController.text = product.name;
      quantityController.text = product.quantity.toString();
      priceController.text = product.price.toString();
      check = true; //check bernilai true
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          //kondisi jika product null makaa text title New Planning jika tidak null maka Edit 
          title: product == null
              ? Text('New Planning',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24))
              : Text('Edit',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
          // tombol untuk menuju halaman sebelumnya
          leading: new IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              //pembuatan text field untuk penginputan
              // nama
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              // quantity
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              // harga
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
                // tombol untuk proses save yang diinputkan oleh user
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan, // background
                        onPrimary: Colors.white, // foreground
                      ),
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (product == null) { // jika objek product bernilai null maka objek product menerima inputan user
                            product = Product(
                                nameController.text,
                                int.parse(quantityController.text),
                                int.parse(priceController.text));
                          } else { // jika tidak kosong maka proses pengeditan. Jadi inputan yang sudah ada diganti oleh nilai variabel dari objek product
                            product.name = nameController.text;
                            product.quantity =
                                int.parse(quantityController.text);
                            product.price = int.parse(priceController.text);
                          }
                          // kembali ke layar sebelumnya dengan membawa objek perencanaan
                          Navigator.pop(context, product);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    // tombol batal
                    Expanded(
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // kembali ke layar sebelumnya
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
