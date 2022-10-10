import 'package:flutter/material.dart';
import 'package:uts_osy/models/calculate.dart';

class DetailOfResultCalculating extends StatelessWidget {
  const DetailOfResultCalculating({
    Key key,
    @required this.Carts,
  }) : super(key: key);

  final List<Calculate> Carts;  //objek Carts dari List class Calclate bertype final

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8),
        height: 300,
        child: Carts.isEmpty // jika lisview kosong maka akan menampilkan text seperti di bawah
            ? Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10),
                    child: Text("------No History------",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan)),
                  ),
                ],
              )
            : ListView.builder(
              // menggunakan lisview item builder
                itemCount: Carts.length, // jumlah list item
                itemBuilder: (context, index) {
                  int totalPrice =
                      Carts[index].price * Carts[index].quantity;
                      // untuk membangun tampilan dari list item
                  return Card(
                    elevation: 10,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            Carts[index].quantity.toString(),  // menampilkan quantity dari list view sesuai yang diinputkan tadi
                            style: TextStyle(
                                color:
                                    Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                         //  menampilkan  nama, price, dan quantity dari listview sesuai yang diinputkan sebelumnya
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Name - ' + Carts[index].name,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                  'Price           : Rp. ' +
                                      Carts[index]
                                          .price
                                          .toStringAsFixed(0),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              Text(
                                  'Quantity     : ' +
                                      Carts[index]
                                          .quantity
                                          .toStringAsFixed(0) +
                                      ' pcs',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ));
  }
}