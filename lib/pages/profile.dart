import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uts_osy/screens/Welcome/welcome_screen.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key key, this.user}) : super(key: key);
  @override

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Profile',style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
      ),
      body:  SafeArea(
              child: Column(
              children: [
                _heading("Your Profile"),
                const SizedBox(
                  height: 6,
                ),
                _detailsCard(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
                  primary: Colors.cyan, elevation: 0,
                  minimumSize: const Size.fromHeight(50),),
                  onPressed: () {
                    _signOut().whenComplete(() {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => WelcomeScreen()));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
    );
  }

  Widget _heading(String heading) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Text(
        heading,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            //row for each deatails
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(widget.user.displayName),
            ),
            const Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(widget.user.email),
            ),
          ],
        ),
      ),
    );
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}