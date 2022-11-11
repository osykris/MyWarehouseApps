import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:uts_osy/db_helper.dart';
import 'package:uts_osy/models/entry.dart';
import 'package:uts_osy/pages/entry_entry.dart';

//pendukung program asinkron
class EntryEntry extends StatefulWidget {
  @override
  EntryEntryState createState() => EntryEntryState();
}

class EntryEntryState extends State<EntryEntry> {
  @override
  DbHelper dbHelper = DbHelper(); //pembuatan obejk dbHelper dari class DBHelper
  //variabel count dan total_money yang menampung nilai 0 bertype int
  int count = 0;
  int total_money = 0;
  List<Entry> itemList; // obejek itemList yang merujuk dari List class Enntry

  @override //override fungsi initState() untuk melakukan generate daftar widget berdasarkan data yang sudah kita tambahkan
  void initState() {
    super.initState();
    updateListView(); // agar nantinya tampilan select db tetap ada walaupun aplikasi sudah diclose
    jumlah();
  }

  void jumlah() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Entry>> itemListFuture = dbHelper.getEntryList();
      itemListFuture.then((itemList) {
        setState(() {
          for (var i = 0; i < itemList.length; i++) {
            if (itemList[i].type.toString() == 'Masuk') {
              total_money = total_money + itemList[i].total;
            } else if (itemList[i].type.toString() == 'Keluar') {
              total_money = total_money - itemList[i].total;
            }
          }
        });
      });
    });
  }

  Widget build(BuildContext context) {
    if (itemList == null) {
      //kondisi jika kosong maka list dari classEntry akan diisi oleh obej itemList
      itemList = List<Entry>();
    }
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          //header text
          'Warehouse Finance',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            child: Image.asset('assets/images/money.jpg'), //banner
          ),
        ),
        Expanded(
          child: createListView(), // memanggil fungsi dari createListView
        ),
        Container(
          height: 70,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Text(
                "Total : Rp. $total_money,00", //menampilkan total uang masuk
                style: TextStyle(fontSize: 22, color: Colors.white)),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        // button
        onPressed: () async {
          var item = await navigateToEntryForm(
              context, null); //memanggil navigateToEntryForm
          if (item != null) {
            //jika item tidak kosong
            int result = await dbHelper.insertEntry(item); //memasukkan item
            if (item.type == 'Masuk') {
              setState(() {
                this.total_money += item.total;
              });
            } else {
              setState(() {
                this.total_money -= item.total;
              });
            }
            if (result > 0) {
              //jika result lebih dari 0
              updateListView(); //maka memanggil fungsi updateListView
            }
          }
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

// fungsi untuk menuju ke halaman EntryInput ketika floating button dijalankkan
  Future<Entry> navigateToEntryForm(BuildContext context, Entry item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryInput(item);
    }));
    return result;
  }

  //pembuatan listview untuk menampilkan inputan database yang sebelumnya diinputkan oleh user
  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
         if (itemList[index].type == 'Keluar') {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Rp." + this.itemList[index].total.toString() + ",00",
              style: textStyle,
            ),
            subtitle: Text(this.itemList[index].titlee.toString()),
            onTap: () async {},
            // trailing: GestureDetector(
            //   child: Icon(Icons.delete, color: Colors.red),
            //   onTap: () async {
              
            //     //Panggil Fungsi untuk Delete dari DB berdasarkan Item
            //     _showDeleteDialog(context, itemList[index].entryId);
            //   },
            // ),
          ),
        );
         } else {
           return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Rp." + this.itemList[index].total.toString() + ",00",
              style: textStyle,
            ),
            subtitle: Text(this.itemList[index].titlee.toString()),
            onTap: () async {},
            // trailing: GestureDetector(
            //   child: Icon(Icons.delete, color: Colors.red),
            //   onTap: () async {
            //     //Panggil Fungsi untuk Delete dari DB berdasarkan Item
            //     _showDeleteDialog(context, itemList[index].entryId);
            //   },
            // ),
          ),
        );
         }
      },
    );
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
                  // tombol hapus dia akan memamnggil fungsi deleteEntry yang menerima parameter dari item yang diklik

                  onPressed: () async {
                    var result = await dbHelper.deleteEntry(itemId);
                    if (result > 0) {
                      //jika result lebih dari 0 maka
                      Navigator.pop(context); //kembali kehalaman sebelumnya
                      updateListView(); // setelah terhapus akan memanggil fungsi updateListview
                      _showSuccessSnackBar(Text("Deleted",
                          style: TextStyle(
                              color: Colors
                                  .white))); //memanggil fungsi sanckbar dengan pesan deleted
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
      Future<List<Entry>> itemListFuture = dbHelper.getEntryList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
