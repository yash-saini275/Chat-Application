import 'package:flutter/material.dart';
import 'package:frontend/components/rounded_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final url = 'http://127.0.0.1:8080/chat/signup/';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showSpinner = false;
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: usernameController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  username = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    var response = await http.post(
                      url,
                      body: {'username': username, 'password': password},
                    );
                    var responseBody = jsonDecode(response.body);
                    // print(response.statusCode);
                    if (response.statusCode == 200) {
                      Navigator.pushNamed(context, LoginScreen.id);
                    } else {
                      throw Exception(responseBody['msg']);
                    }
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // print(e);
                  }
                  usernameController.clear();
                  passwordController.clear();
                },
                buttonColor: Colors.blueAccent,
                buttonTitle: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
