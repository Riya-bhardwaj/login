import 'package:flutter/material.dart';
import 'package:movie/Signup.dart';
import 'package:movie/signin.dart';

void main() {
  runApp(Login());
}
bool _isLoading=false;
class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[Signin(),
          _showCircularProgress(),

        ],
      )),
    ));
  }
}
Widget _showCircularProgress(){


  if (_isLoading) {

    return Center(child: CircularProgressIndicator());
  }
  return Container(height: 0.0, width: 0.0,);
}