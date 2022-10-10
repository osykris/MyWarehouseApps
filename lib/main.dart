import 'package:flutter/material.dart';
import 'package:uts_osy/pages/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan), //temanya berwana cyan
      debugShowCheckedModeBanner: false, //agar banner debug hilang
      home:
          HomeScreen(), //di bagian home ini memanggil class HomeScreen sebagai tampilan utama
    );
  }
}

