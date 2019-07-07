import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie/widget.dart';

String email;
String passward;
String Name;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

final TextEditingController passwordcontroller = TextEditingController();
enum FormMode { LOGIN, SIGNUP }
FormMode _formMode = FormMode.LOGIN;


class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   widget Signupwidgets=new widget();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blue[900],
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: new Text(
                        "dfdfsfffs",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    width: 350,
                    color: Colors.white,
                    child: Signupwidgets.NameTextfield(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    color: Colors.white,
                    child: Signupwidgets.EmailTextfield(),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 350,
                    color: Colors.white,
                    child: Signupwidgets.PasswordTextfield(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    color: Colors.white,
                    child: Signupwidgets.CheckpasswordTextfield(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    width: 350,
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        submit();
                        // add(email, passward, Name);
                        print(email);
                        print(passward);
                        print(Name);
                        _formMode=FormMode.SIGNUP;
                        print("add callesd");
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ));
  }

  void submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    if (_formMode == FormMode.SIGNUP) {
      Map<String, dynamic> successinfo = await Signup();
      if (successinfo == ['success']) {
        print("successful");
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text('alert!'),
                  content: Text(successinfo['message']),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]);
            });
      }
    }
  }

  Future<Map<String, dynamic>> Signup() async {
    final Map<String, dynamic> authdata = {
      'email': email,
      'password': passward,
      'returnSecureToken': true
    };

    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyASnJZNhtRJIU6yKrNs5P5vjZHe4IdL7Kw',
        body: json.encode(authdata),
        headers: {'Content-type': 'application/json'});
    print("email is called");
    print(json.encode(response.body));
    print("hfjdfghfjddfkhj");
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';

    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }
    return {'success':!hasError, 'message': message};
  }


  void add(String _emails, String _passwords, String name) {
    final Map<String, dynamic> info = {
      'email': _emails,
      'passward': _passwords,
      'Name': name,
    };
    http.post("https://myapp-780be.firebaseio.com/780be.json",
        body: json.encode(info));
  }
}
