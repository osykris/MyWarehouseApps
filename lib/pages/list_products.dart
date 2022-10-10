import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:uts_osy/db_helper.dart';
import 'package:uts_osy/models/product.dart';
import 'package:uts_osy/pages/entry_product.dart';

//pendukung program asinkron
class List_Product extends StatefulWidget {
  @override
  List_ProductState createState() => List_ProductState();
}

class List_ProductState extends State<List_Product> {
  @override
  DbHelper dbHelper = DbHelper(); //pembuatan obejk dbHelper dari class DBHelper
  //variabel count dan total_money yang menampung nilai 0 bertype int
  int count = 0;
  int total_money = 0;
  List<Product> itemList; //obejek itemList yang merujuk dari List class Product
 
  @override
  void initState() { //override fungsi initState() untuk melakukan generate daftar widget berdasarkan data yang sudah kita tambahkan
    super.initState();
    updateListView(); // agar nantinya tampilan select db tetap ada walaupun aplikasi sudah diclose
  }

  Widget build(BuildContext context) {
    if (itemList == null) {
      //kondisi jika kosong maka list dari class Product akan diisi oleh obej itemList
      itemList = List<Product>();
    }
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('Puchase Planning', //header text
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
        ),
        body: Column(children: [
          Expanded(
            child: Container(
              child: Image.asset('assets/images/Shoppingfun.jpg'), //banner
            ),
          ),
          Expanded(
            child: createListView(), // memanggil fungsi dari createListView
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var item = await navigateToEntryForm(context, null); //memanggil navigateToEntryForm
            if (item != null) { //jika item tidak kosong
              int result = await dbHelper.insertProduct(item); //masukkan item
              if (result > 0) {  //jika result lebih dari 0
                updateListView(); //maka memanggil fungsi updateListView
              }
            }
          },
          tooltip: 'Increment',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }

// fungsi untuk menuju ke halaman Entry_Product ketika floating button dijalankkan
  Future<Product> navigateToEntryForm(
      BuildContext context, Product item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Entry_Product(item);
    }));
    return result;
  }
//pembuatan listview untuk menampilkan inputan database yang sebelumnya diinputkan oleh user
  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
                title: Text(
                  this.itemList[index].name.toString(),
                  style: textStyle,
                ),
                subtitle: Text(this.itemList[index].quantity.toString() +
                    " /pcs" +
                    "\nRp. " +
                    this.itemList[index].price.toString() +
                    ",00"),
                onTap: () async {//card dapat ditekan untuk proses edit data
                  var item =
                      await navigateToEntryForm(context, this.itemList[index]); //memanggil navigateToEntryForm dengan parameter context dan objek itemList dengan index indeex
                  if (item != null) { //jika item tidak kosong
                    int result = await dbHelper.updateProduct(item); //proses update dengan memanggil fungsi update dari objek dbHelper
                    if (result > 0) { //jika result lebih dari 0
                      updateListView(); // maka memanggil  updatelistview
                    }
                  }
                },
                trailing: GestureDetector(
                    child: Icon(Icons.delete, color: Colors.red),
                    onTap: () async {
                      //Panggil Fungsi untuk Delete dari DB berdasarkan Item
                      _showDeleteDialog(context, itemList[index].id);
                    })),
          );
        });
  }
//pembuatan objek globalkey sebagai  pendukung snackbar
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  //Notofikasi telah terhapus di bawah sendiri nanti tampilannya
  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
  //pembuatan dialog seperti popup
  _showDeleteDialog(BuildContext context, itemId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.white))),
              TextButton(
                 // tombol hapus dia akan memamnggil fungsi deleteProduct yang menerima parameter dari item yang diklik
                  onPressed: () async {
                    var result = await dbHelper.deleteProduct(itemId);
                    if (result > 0) { //jika result lebih dari 0 maka
                      Navigator.pop(context); //kembali kehalaman sebelumnya
                      updateListView(); /// setelah terhapus akan memanggil fungsi updateListview
                      _showSuccessSnackBar(Text("Deleted",
                          style: TextStyle(color: Colors.white)));//memanggil fungsi sanckbar dengan pesan deleted
                    }
                  },
                  child: Text("Delete")),
            ],
            title: Text("Are you sure you want to delete this?"),
          );
        });
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Product>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
