import 'package:flutter/material.dart';
import 'package:movie/Signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
class widget {
  Widget EmailTextfield() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "email address",
        fillColor: Colors.white,
        icon: Icon(
          Icons.mail,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.all(15.0),
      ),
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (value) => email = value,
    );
  }


  Widget PasswordTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "password",
        fillColor: Colors.white,
        icon: Icon(Icons.lock),
        contentPadding: EdgeInsets.all(15.0),
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return "please enter valid passward";
        }
      },
      onSaved: (String value) {
        passward = value;
      },
    );
  }
  Widget CheckpasswordTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Confirm password",
        fillColor: Colors.white,
        icon: Icon(Icons.lock),
        contentPadding: EdgeInsets.all(15.0),
      ),
      obscureText: true,
      validator: (String value) {
        if (passwordcontroller.text != value) {
          return "please enter valid passward";
        }
      },
      onSaved: (String value) {
        passward = value;
      },
    );
  }
  Widget NameTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "User Name",
        fillColor: Colors.white,
        icon: Icon(Icons.perm_identity),
        contentPadding: EdgeInsets.all(15.0),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return "please enter valid passward";
        }
      },
      onSaved: (String value) {
        Name = value;
      },
    );
  }

}