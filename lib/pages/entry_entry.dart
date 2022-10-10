import 'package:flutter/material.dart';
import 'package:uts_osy/db_helper.dart';
import 'package:uts_osy/models/entry.dart';

class EntryInput extends StatefulWidget {
  // pembuatan class EntryInputn yang memperluaskan statefullwidget
  final Entry entry; // objek entry dari Class Entry bertype final
  EntryInput(this.entry); //konstruktor yang menerima parameter entry
  @override
  EntryInputState createState() => EntryInputState(this.entry);
}

//class controller
class EntryInputState extends State<EntryInput> {
  String dropdownAtas;
  String dropdownValue = 'Masuk';
  DbHelper dbHelper = DbHelper(); //pembuatan obejk dbHelper dari class DBHelper
  int count = 0;
  ///variabel count dengan type data int yang menamung angka 0
  List<Entry> itemList; //objek itemList yang merujuk dari List class Enntry

  Entry entry; //objek entry dari class Entry
  EntryInputState(this.entry); //konstruktor yang menerima parameter entry

  //pembuatan text editing controller
  TextEditingController titleeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  void initState() {
    //override fungsi initState() untuk melakukan generate daftar widget berdasarkan data yang sudah kita tambahkan
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool check =
    false; // variabel check dengan type boolean yang menampung nilai false
    //kondisi jika entry null
    if (entry != null) {
      //variabel titlee dari entry ini diisi oleh nilai dari titleeController
      titleeController.text = entry.titlee.toString();
      typeController.text = entry.type.toString();
      //variabel total dari entry ini diisi oleh nilai dari totalController
      totalController.text = entry.total.toString();
      check = true; //check bernilai true
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          //kondisi jika entry null makaa text title Add New Entry jika tidak null maka Edit entry
          title: entry == null
              ? Text('Add New Money',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24))
              : Text('Edit Money'),
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
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              //pembuatan text field untuk penginputan
              // harga
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: titleeController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  items: <String>['Masuk', 'Keluar'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (selectedItem) => setState(() {
                    dropdownValue = selectedItem;
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              // tombol untuk proses save yang diinputkan oleh user
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (entry == null) {
                            //jika kosong maka objek entry menerima inputan user
                            entry = Entry(titleeController.text,
                                    this.dropdownValue,
                                    int.parse(totalController.text));
                          }
                          // kembali ke layar sebelumnya dengan membawa objek pemsukkan
                          Navigator.pop(context, entry);
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
