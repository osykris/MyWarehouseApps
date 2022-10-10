import 'package:flutter/material.dart';

class ResultOfCalculating extends StatelessWidget {
  const ResultOfCalculating({
    Key key,
    @required this.jumlah,
    @required this.totalPrice,
  }) : super(key: key);

//deklarasi variabel
  final int jumlah; 
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Total Purchase    : ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      jumlah.toString() +
                          " pcs ", // memanggil fungsi jumlah untuk menampilkanya
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Total Price            : ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Rp. ' +
                          totalPrice.toStringAsFixed(
                              0), // memanggil fungsi jumlahHarga untuk menampilkanya
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}