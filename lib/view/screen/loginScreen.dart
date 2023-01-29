import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/view/screen/mainScreen.dart';
import 'package:homestay_raya/view/screen/registrationScreen.dart';
import 'package:homestay_raya/view/shared/serverConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _passwordVisible1 = true;
  bool _isChecked = false;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var screenWidth, screenHeight;
  double cardWidth = 0.0;

  @override 
  void initState() { 
    super.initState(); 
    loadPref(); 
  } 


  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth <= 600){
      cardWidth = screenWidth;
    }else{
      cardWidth = 400.00;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: cardWidth,
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column( children: [
                    TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".") 
                            ? "enter a valid email" 
                            : null, 
                        decoration: const InputDecoration( 
                        labelText: 'Email', 
                        labelStyle: TextStyle(), 
                        icon: Icon(Icons.email), 
                        focusedBorder: OutlineInputBorder( 
                        borderSide:BorderSide( width: 2.0), ))
                      ),
                       TextFormField(
                        controller: _passEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _passwordVisible1, 
                        decoration: InputDecoration( 
                        labelText: 'Password', 
                        labelStyle: const TextStyle(), 
                        icon: const Icon(Icons.password), 
                        focusedBorder: const OutlineInputBorder( 
                        borderSide:BorderSide( width: 2.0),),
                        suffixIcon: IconButton(icon: Icon( _passwordVisible1 
                                      ? Icons.visibility 
                                      : Icons.visibility_off, 
                                    ), 
                        onPressed: () { 
                          setState(() { 
              	          _passwordVisible1 = !_passwordVisible1; 
	  	                  }); 
                        }, 
                        ),
                        )
                      ),
                      const SizedBox(height: 8,),
                      Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [ 
                          Checkbox( 
                            value: _isChecked, 
                            onChanged: (bool? value) { 
                                setState(() { 
                                    _isChecked = value!;
                                    saveremovepref(value); 
                                }); 
                            }, 
                          ), 
                          Flexible( 
                              child: GestureDetector( 
                                onTap: null, 
                                child: const Text('Remember Me', 
                                  style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold,)), 
                              ),
                          ), 
                          MaterialButton( 
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)), 
                              minWidth: 115, 
                              height: 50, 
                              elevation: 10, 
                              onPressed: _loginUser, 
                              child: const Text('Login'), 
                          ), 
                        ], 
                      ),
                      Column(
                        children: [
                          GestureDetector(
                          onTap: _goRegister,
                          child: const Text("Don't have an account? Register First", style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 8,),
                          GestureDetector(
                          onTap: _goMainScreen,
                          child: const Text("Go back to Main Screen", style: TextStyle(fontSize: 18)),
                          )
                        ]
                      ), 
                  ],
                  ),
                ),
              )
            ),
          )
        ),
      ),
    );
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) { 
        Fluttertoast.showToast( 
            msg: "Please fill in the login credentials", 
            toastLength: Toast.LENGTH_SHORT, 
            gravity: ToastGravity.BOTTOM, 
            timeInSecForIosWeb: 1,   
            fontSize: 14.0); 
        return; 
    } 
    String _email = _emailEditingController.text; 
    String _pass = _passEditingController.text; 
    http.post(Uri.parse("${ServerConfig.Server}/Homestay_Raya/php/login_user.php"), 
        body: {"email": _email, "password": _pass}).then((response) { 
          print(response.body);
          if (response.statusCode == 200){
            var jsonResponse = json.decode(response.body);
            User user = User.fromJson(jsonResponse['data']);

            Navigator.push(context, 
            MaterialPageRoute(builder: (content) => MainScreen(user: user,)));
          }else {
            Fluttertoast.showToast( 
              msg: "Login Failed", 
              toastLength: Toast.LENGTH_SHORT, 
              gravity: ToastGravity.BOTTOM, 
              timeInSecForIosWeb: 1, 
              fontSize: 14.0);
          }
        }); 
  }

  void _goRegister() {
    Navigator.push(context, 
    MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _goMainScreen() {
    User user = User(
        id: "0",
        name: "unregistered",
        email: "unregistered",
        phone: "0123456789",
        address: "na",
        regdate: "0");
    Navigator.push(context, 
    MaterialPageRoute(builder: (content) => MainScreen(user: user,)));
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text; 
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value){
      if (!_formKey.currentState!.validate()) { 
        Fluttertoast.showToast( 
            msg: "Please fill in the login credentials", 
            toastLength: Toast.LENGTH_SHORT, 
            gravity: ToastGravity.BOTTOM, 
            timeInSecForIosWeb: 1,
            fontSize: 14.0); 
            _isChecked = false; 
            return;
      }
      await prefs.setString('email', email); 
      await prefs.setString('pass', password); 
      Fluttertoast.showToast( 
          msg: "Preference Stored", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0);   
    } else{
      await prefs.setString('email', ''); 
      await prefs.setString('pass', ''); 
      setState(() { 
        _emailEditingController.text = ''; 
        _passEditingController.text = ''; 
        _isChecked = false; 
      }); 
      Fluttertoast.showToast( 
          msg: "Preference Removed", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0); 
    }
  }

  Future<void> loadPref() async { 
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    String email = (prefs.getString('email')) ?? ''; 
    String password = (prefs.getString('pass')) ?? ''; 
    if (email.length > 1) { 
      setState(() { 
        _emailEditingController.text = email; 
        _passEditingController.text = password; 
        _isChecked = true; 
      }); 
    } 
  } 
}
