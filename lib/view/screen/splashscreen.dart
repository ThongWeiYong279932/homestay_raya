import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/view/screen/mainScreen.dart';
import 'package:homestay_raya/view/shared/serverConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
          Text("Homestay Raya", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
          CircularProgressIndicator(),
          Text("Version 1.0")
        ],
    ),
      ));
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    String _email = (prefs.getString('email')) ?? ''; 
    String _password = (prefs.getString('pass')) ?? ''; 
    if (_email.isNotEmpty) {
      http.post(Uri.parse("${ServerConfig.Server}/Homestay_Raya/php/login_user.php"), 
        body: {"email": _email, "password": _password}).then((response) { 
          if (response.statusCode == 200){
            var jsonResponse = json.decode(response.body);
            User user = User.fromJson(jsonResponse['data']);
            Timer( 
              const Duration(seconds: 3), 
              () => Navigator.pushReplacement( 
                  context, 
                  MaterialPageRoute( 
                      builder: (content) => MainScreen(user: user)))); 
          }
        }); 
    }else {
      User user = User(
        id: "0",
        name: "unregistered",
        email: "unregistered",
        phone: "0123456789",
        address: "na",
        regdate: "0");
      Timer( 
        const Duration(seconds: 5), 
        () => Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}