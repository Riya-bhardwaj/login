import 'package:flutter/material.dart';
import 'package:movie/Signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie/widget.dart';


String email;
String passward;
String id;
String token;


class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

enum FormMode { LOGIN, SIGNUP }

FormMode _formMode = FormMode.LOGIN;


class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/drive',
  ],
  );

  Future<FirebaseUser> googlesignin() async{
    GoogleSignInAccount _googlesigninaccount=await _googleSignIn.signIn();
    GoogleSignInAuthentication _gSA= await _googlesigninaccount.authentication;

    FirebaseUser user= await _firebaseAuth.signInWithGoogle(idToken: _gSA.accessToken, accessToken:_gSA.accessToken);


     print('Signed in as ${user.displayName}');

   return user;
  }



  void signout(){
    _googleSignIn.signOut();
    print("signed out");
  }
   widget Widgets=new widget();
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
                    child: Widgets.EmailTextfield(),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 350,
                    color: Colors.white,
                    child: Widgets.PasswordTextfield(),
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
                        _formKey.currentState.save();
                        print(email);
                        print(passward);
                        submit();
                        print("add callesd");
                      },
                      child: Text(
                        " login",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 110,
                  ),
                  new Center(
                    child: Text(
                      "New User? ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),


                  SizedBox(height: 10),
                  new Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Signup()));
                      },
                      child: Container(
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () {
                        googlesignin().then((FirebaseUser user){
                          print(user) ;
                        }).catchError((e){
                          print(e);
                        });
                      },
                      child: Text("Google Sign in",style: TextStyle(fontSize: 20),)
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                        onPressed: () {
                          signout();
                        },
                        child: Text("Sign out",style: TextStyle(fontSize: 20),)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    if (_formMode == FormMode.LOGIN) {
      Map<String, dynamic> successinfo = await login();
      if (successinfo == ['success']) {
        print("successful");
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text('Alert!'),
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

  Future<Map<String, dynamic>> login() async {
    _isLoading = true;

    final Map<String, dynamic> authdata = {
      'email': email,
      'password': passward,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyASnJZNhtRJIU6yKrNs5P5vjZHe4IdL7Kw',
        body: json.encode(authdata),
        headers: {'Content-type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    id = responseData['localId'];
    token = responseData['idToken'];
    print(json.decode(response.body));
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;

    return {'success': !hasError, 'message': message};
  }





}
