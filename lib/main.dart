import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:uts_osy/UI/argument/transaction_details_args.dart';
import 'package:uts_osy/UI/transactions_screen.dart';
import 'package:uts_osy/UI/items_screen.dart';
import 'package:uts_osy/UI/transaction_details_screen.dart';
import 'package:uts_osy/providers/image_picker_provider.dart';
import 'package:uts_osy/providers/item_provider.dart';
import 'package:uts_osy/providers/transaction_provider.dart';
import 'package:uts_osy/services/hive_service.dart';
import 'package:uts_osy/pages/about_me.dart';
import 'package:uts_osy/pages/calculate_transaction.dart';
import 'package:uts_osy/pages/list_entry.dart';
import 'package:uts_osy/pages/profile.dart';
import 'package:uts_osy/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'package:uts_osy/screens/Welcome/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService().initHive();
   runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ItemProvider>(
      create: (context) => ItemProvider(),
    ),
    ChangeNotifierProvider<TransactionProvider>(
      create: (context) => TransactionProvider(),
    ),
    ChangeNotifierProvider<ImagePickerProvider>(
      create: (context) => ImagePickerProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan), //temanya berwana cyan
      debugShowCheckedModeBanner: false, //agar banner debug hilang
      // to get size
      home: WelcomeScreen(),
    );
  }
}

class WarehouseRecording extends StatelessWidget {
  const WarehouseRecording({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warehouse Management',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.cyan
        ),
      ),
      initialRoute: "/transactions",
      routes: {
        "/transactions": (context) => const TransactionsScreen(),
        "/items": (context) => const ItemsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/transactionDetails") {
          final args = settings.arguments as TransactionsDetailsArgument;
          return MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              transaction: args.transaction,
              item: args.item,
            ),
          );
        }
        return null;
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
   final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  // pembuatan class HomeScreen yang memperluaskan statefullwidget
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //pembuatan class _HomeScreenState yang mengextend State dari class HomeScreen
  @override
  Widget build(BuildContext context) {
    // to get size
    var size = MediaQuery.of(context).size;

    // style
    var cardTextStyle = TextStyle(
        fontFamily: "Montserrat Regular",
        fontSize: 14,
        color: Color.fromRGBO(63, 63, 63, 1));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            // //banner
            // height: size.height * .3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/top_header.png')),
            ),
          ),
          Padding(
          padding: EdgeInsets.only(top: 396),
           child:Container(
            // //banner
            // height: size.height * .3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('assets/images/footer.png')),
            ),
          ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  //banner yang ada gambar dan keterangan
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/Ware.png'),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Text('Hi, ' +
                            //   widget.user.displayName + '!',
                            //   style: TextStyle(
                            //     fontFamily: "Montserrat Medium",
                            //     color: Colors.white,
                            //     fontSize: 12,
                            //   ),
                            // ),
                            Text(
                              'My Warehouse Apps',
                              style: TextStyle(
                                fontFamily: "Montserrat Medium",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Berisi fitur fitur (dengan card yang nanti jika diklik akan menuju ke halaman selanjutnya)
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 2,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EntryEntry()),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 170,
                                    child: Image.asset(
                                        'assets/images/customers.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    'Warehouse Finance',
                                    style: cardTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    child: Image.asset(
                                        'assets/images/Shoppingfun.jpg'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    'Purchase Plan',
                                    style: cardTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WarehouseRecording()),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    child: Image.asset(
                                        'assets/images/products.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    'Items Recording',
                                    style: cardTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                           onTap: () {
                            _signOut().whenComplete(() {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    child: Image.asset(
                                        'assets/images/logout.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    'Sign Out',
                                    style: cardTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}

