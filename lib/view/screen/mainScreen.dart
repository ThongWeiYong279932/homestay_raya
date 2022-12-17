import 'package:flutter/material.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/view/screen/homestayListScreen.dart';

import 'package:homestay_raya/view/screen/loginScreen.dart';

import 'profileScreen.dart';
import 'registrationScreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Main Screen"), 
        actions: [
          IconButton(onPressed: _registrationForm, icon: Icon(Icons.app_registration)),
          IconButton(onPressed: _loginForm, icon: Icon(Icons.login)),

        ],),
        body: const Center(
          child: Text("Main Screen"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text(widget.user.email.toString()), // keep blank text because email is required
                accountName: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                          child: Icon(
                            Icons.check,
                          ),
                      ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.user.name.toString()),
                  ],
                ),
              ],
            ),
              ),
              ListTile(
                title: const Text('Main Screen'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (content) => MainScreen(user:widget.user)));
                },
              ),
              ListTile(
                title: const Text('Homestay List'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (content) => HomestayListScreen(user: widget.user)));
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (content) => ProfileScreen(user: widget.user)));
                },
              ),
            ]
          ),
        ),
      ),
    );
  }

 void _registrationForm() {
    Navigator.push(context, 
    MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }


  void _loginForm() {
     Navigator.push(context, 
     MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
