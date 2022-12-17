import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../shared/config.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isChecked = false;
  bool _passwordVisible1 = true;
  bool _passwordVisible2 = true;
  String eula = ""; 
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController(); 

  @override
  void initState(){
    super.initState();
    loadEula();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration Form")),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      validator: (val) => val!.isEmpty || (val.length < 3) 
                          ? "name must be longer than 3" 
                          : null, 
                      decoration: const InputDecoration( 
                      labelText: 'Name', 
                      labelStyle: TextStyle(), 
                      icon: Icon(Icons.person), 
                      focusedBorder: OutlineInputBorder( 
                      borderSide:BorderSide( width: 2.0), ))
                    ),
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
                      controller: _phoneEditingController,
                      keyboardType: TextInputType.phone, 
                      decoration: const InputDecoration( 
                      labelText: 'Phone Number', 
                      labelStyle: TextStyle(), 
                      icon: Icon(Icons.phone), 
                      focusedBorder: OutlineInputBorder( 
                      borderSide:BorderSide( width: 2.0), ))
                    ),
                    TextFormField(
                      controller: _passEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _passwordVisible1, 
                      validator: (val) => validatePassword(val.toString()), 
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
                    TextFormField(
                      controller: _pass2EditingController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _passwordVisible2,
                      validator: (val) { 
                        validatePassword(val.toString()); 
                        if (val != _passEditingController.text) { 
        	                return "password do not match"; 
                        } else { 
                          return null; 
                        }
                      },
                      decoration: InputDecoration( 
                      labelText: 'Re-enter Password',  
                      labelStyle: const TextStyle(), 
                      icon: const Icon(Icons.password), 
                      focusedBorder: const OutlineInputBorder( 
                      borderSide:BorderSide( width: 2.0), ),
                      suffixIcon: IconButton(icon: Icon( _passwordVisible2 
                                    ? Icons.visibility 
                                    : Icons.visibility_off, 
                                  ), 
                      onPressed: () { 
                        setState(() { 
            	          _passwordVisible2 = !_passwordVisible2; 
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
                              }); 
                          }, 
                        ), 
                        Flexible( 
                            child: GestureDetector( 
                              onTap: _showEULA, 
                              child: const Text('Agree with terms', 
                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold,)), 
                            ),
                        ), 
                        MaterialButton( 
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)), 
                            minWidth: 115, 
                            height: 50, 
                            elevation: 10, 
                            onPressed: _registerAccount, 
                            child: const Text('Register'), 
                        ), 
                      ], 
                    ), 
                ],)
                ),
            ),
          ),
        ),
      ),
    );
  }

  void _registerAccount() {
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _phone = _phoneEditingController.text;
    String _passA = _passEditingController.text;
    String _passB = _pass2EditingController.text;
    
    if(!_formKey.currentState!.validate()){
      Fluttertoast.showToast( 
          msg: "Please complete the registration form first", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0); 
      return; 
    }
    if (_passA != _passB){
      Fluttertoast.showToast( 
          msg: "Password not match. Please check your password", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0); 
      return; 
    }
    if(!_isChecked){
      Fluttertoast.showToast( 
          msg: "Please accept terms", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0); 
      return; 
    }
    showDialog( 
      context: context, 
      builder: (BuildContext context) { 
        return AlertDialog( 
          shape: const RoundedRectangleBorder( 
              borderRadius: BorderRadius.all(Radius.circular(20.0))), 
          title: const Text( 
            "Register new account?", 
            style: TextStyle(), 
          ), 
          content: const Text("Are you sure?", 
              style: TextStyle()), 
          actions: <Widget>[ 
            TextButton( 
              child: const Text( 
                "Yes", 
                style: TextStyle(), 
              ), 
              onPressed: () { 
                Navigator.of(context).pop();
                _registerUser(_name, _email, _phone, _passA); 
              }, 
            ), 
            TextButton( 
              child: const Text( 
                "No", 
                style: TextStyle(), 
              ), 
              onPressed: () { 
                Navigator.of(context).pop(); 
              }, 
            ), 
          ], 
        ); 
      }, 
    ); 
  }

  String? validatePassword(String value) { 
      String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{10,}$'; 
      RegExp regex = RegExp(pattern); 
      if (value.isEmpty) { 
          return 'Please enter password'; 
      } else { 
          if (!regex.hasMatch(value)) { 
            String s1 = 'Enter valid password.\n'
                        'Password must contain at least: \n'
                        '1 capital letter\n'
                        '1 small letter\n'
                        '1 number\n'
                        '10 characters\n';
              return s1; 
          } else { 
              return null; 
          } 
      } 
  }

  loadEula() async { 
    eula = await rootBundle.loadString('assets/text/eula.txt'); 
  }

  void _showEULA() {     
    loadEula(); 
    showDialog( 
      context: context, 
      builder: (BuildContext context) { 
        return AlertDialog( 
          title: const Text( 
            "EULA", 
            style: TextStyle(), 
          ), 
          content: SizedBox(
            height: 300,
            child: Column( 
              children: <Widget>[ 
                Expanded( 
                  flex: 1, 
                  child: SingleChildScrollView( 
                      child: RichText( 
                    softWrap: true, 
                    textAlign: TextAlign.justify, 
                    text: TextSpan( 
                        style: const TextStyle( 
                          fontSize: 12.0,
                          color: Colors.black, 
                        ), 
                        text: eula), 
                  )), 
                ), 
              ], 
            ), 
          ), 
          actions: <Widget>[ 
            TextButton( 
              child: const Text( 
                "Close", 
              ), 
              onPressed: () { 
                Navigator.of(context).pop(); 
              }, 
            ) 
          ], 
        ); 
      }, 
    ); 
  }
  
  void _registerUser(String name, String email, String phone, String password) {
    try{
      http.post(Uri.parse("${Config.Server}/Homestay_Raya/php/register_user.php"), 
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "register": "register"
          }).then((response) { 
            var data = jsonDecode(response.body);
            if ((response.statusCode == 200) && data['status'] == "success"){
              Fluttertoast.showToast( 
              msg: "Account Registration Success", 
              toastLength: Toast.LENGTH_SHORT, 
              gravity: ToastGravity.BOTTOM, 
              timeInSecForIosWeb: 1, 
              fontSize: 14.0); 
              return; 
            }else{
              Fluttertoast.showToast( 
              msg: "Email has been registered", 
              toastLength: Toast.LENGTH_SHORT, 
              gravity: ToastGravity.BOTTOM, 
              timeInSecForIosWeb: 1, 
              fontSize: 14.0); 
              return; 
            }
          }); 
    }catch (e){
        Fluttertoast.showToast( 
        msg: "Account Registration Failed", 
        toastLength: Toast.LENGTH_SHORT, 
        gravity: ToastGravity.BOTTOM, 
        timeInSecForIosWeb: 1, 
        fontSize: 14.0); 
        return; 
    }
  } 


}
