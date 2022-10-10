import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uts_osy/models/calculate.dart';
import 'package:uts_osy/widgets/detail_resultCalc.dart';
import 'package:uts_osy/widgets/result_calculating.dart';

// ignore: must_be_immutable
class CalculateTransaction extends StatefulWidget { // pembuatan class CalculateTransaction yang memperluaskan statefullwidget
  @override
  _CalculateTransactionState createState() => _CalculateTransactionState();
}

class _CalculateTransactionState extends State<CalculateTransaction> { // class _CalculateTransactionState yang mengextend State
  //pembuatan text editing controller
  TextEditingController namaC = TextEditingController();

  TextEditingController hargaC = TextEditingController();

  TextEditingController jumlahC = TextEditingController();

  final minimumPadding = 5.0; // deklarasi final minimumPadding yang menapung sebanyak 5.0

  final List<Calculate> Carts = []; // membuat sebuah list baru dengan nama Cart dari kelas Calculate dengan type final

  void SaveItem() {
    // fungsi untuk menyimpan inputan user
    final name = namaC.text;
    final price = int.parse(hargaC.text);
    final qty = int.parse(jumlahC.text);

    if (name.isEmpty || price == 0 || qty == 0) {
      // kondisi jika kosong tidak mengembalikan apa2
      return;
    }
    _tambahItemBaru(name, price, qty); // meemanggil fungsi _tambahItemBaru yang menerima parameter name, price, quantity
  }

  // fungsi untuk menampilkan inputan dari user, akan terus terupdate jika terjadi penambahan inputan baru
  void _tambahItemBaru(String name, int price, int qty) {
    var product = Calculate(
        id: DateTime.now().toString(), name: name, price: price, quantity: qty);
    setState(() {
      Carts.add(product);
    });
  }

  void _resetCarts() { // fungsi untuk menghapus semua item yang ada di list Carts
    setState(() {
      Carts.clear();
    });
  }

  int get jumlah {
    // fungsi untuk menghitung jumlah quntity pada listview
    return Carts.fold(0, (sum, item) {
      return sum += item.quantity;
    });
  }

  int get totalPrice {
    // fungsi untuk menghitung jumlah hargapada listview
    return Carts.fold(0, (sum, item) {
      int jumlah_harga = item.quantity * item.price;
      return sum += jumlah_harga;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculate Transactions', //sebagai header
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 29, right: 10, left: 10),
            child: Column(
              children: <Widget>[
                //pembuatan text field untuk penginputan
                Padding(
                  padding: EdgeInsets.only(
                    bottom: minimumPadding,
                  ),
                  child: TextField(
                    controller: namaC,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "e.g: Indomie",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: minimumPadding,
                    bottom: minimumPadding,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: hargaC,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Price",
                              hintText: "e.g: 2000",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      Container(
                        width: minimumPadding * 2,
                      ),
                      Container(
                        width: minimumPadding * 20,
                        child: TextField(
                          controller: jumlahC,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Quantity",
                              hintText: "e.g: 4",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                //Tombol untuk perhhitungan
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: SaveItem,
                  ),
                ),
                //Calcularing History
                Container(
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Calculation History",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            )),
                        TextButton( //tombol untuk menghapus semua item yang ada di listview
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _resetCarts(), //dengan memangil fungsi _resertCarts
                        )
                      ],
                    )),
                ResultOfCalculating(jumlah: jumlah, totalPrice: totalPrice), // Memanggil class ResultOfCalculating yg menerima parameter jumlah dan totalPrice
                DetailOfResultCalculating(Carts: Carts) //Memanggil class DetailOfResultCalculating yg menerima parameter Carts
              ],
            ),
          ),
        ],
      ),
    );
  }
}




