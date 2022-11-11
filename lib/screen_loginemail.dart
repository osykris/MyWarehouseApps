import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uts_osy/login_page.dart';

class LoginEmailPage extends StatefulWidget {
  final User user;

  const LoginEmailPage({Key key, this.user}) : super(key: key);
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue[100], Colors.blue[400]],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            color: Colors.blueGrey.shade900,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Logged In',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 40),
                Text(
                  'Name: ' + widget.user.displayName,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Email: ' + widget.user.email,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    _signOut().whenComplete(() {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    });
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                )
              ],
            ),
          ),
        ));
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}
