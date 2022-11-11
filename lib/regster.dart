import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uts_osy/login_page.dart';
import 'package:uts_osy/screen_loginemail.dart';
import '../../../constants.dart';
import '../../../components/already_have_an_account_acheck.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSuccess;
  String _userEmail;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                        controller: _displayName,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.cyan,
                        decoration: InputDecoration(
                          hintText: "Your Name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.book),
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                      child:
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.cyan,
                        decoration: InputDecoration(
                          hintText: "Your email",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.person),
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: Colors.cyan,
                        decoration: InputDecoration(
                          hintText: "Your password",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock),
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      primary: Colors.cyan, elevation: 0,
                      minimumSize: const Size.fromHeight(50),),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          _registerAccount();
                        }
                      },
                      child: Text("Sign Up".toUpperCase()),
                    ),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _registerAccount() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        await user.updateProfile(displayName: _displayName.text);
        final user1 = _auth.currentUser;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginEmailPage(
                  user: user1,
                )));
      }
    } catch (e) {
      _showSuccessSnackBar(
          Text("Failed to register", style: TextStyle(color: Colors.white)));
    }
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
     ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
}
