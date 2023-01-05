import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/view/screen/homestayListScreen.dart';

import 'package:homestay_raya/view/screen/loginScreen.dart';
import 'package:homestay_raya/view/screen/newHomestayScreen.dart';


import 'profileScreen.dart';
import 'registrationScreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Position _position;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Main Screen"), 
        actions: [
          IconButton(onPressed: _registrationForm, icon: Icon(Icons.app_registration)),
          IconButton(onPressed: _loginForm, icon: Icon(Icons.login)),
          PopupMenuButton(itemBuilder: (context){
            return[
              const PopupMenuItem<int>(
                value: 0,
                child: Text("New Homestay"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: const Text("My Order"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0){
              _gotoHomestayRegister();
            }else if (value == 1){
              print("My Order is seleccted");
            }
          }),
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
                title: const Text('User Homestay List'),
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
  
  Future<void> _gotoHomestayRegister() async {
    if (widget.user.id == "0"){
      Fluttertoast.showToast( 
        msg: "Please login first", 
        toastLength: Toast.LENGTH_SHORT, 
        gravity: ToastGravity.BOTTOM, 
        timeInSecForIosWeb: 1, 
        fontSize: 14.0); 
        return; 
    }
    if (await _checkGetLocPermission()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => newHomestayScreen(
                  position: _position,
                  user: widget.user,
                  )));
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<bool> _checkGetLocPermission() async {
    bool serviceEnabled; 
    LocationPermission permission; 
    serviceEnabled = await Geolocator.isLocationServiceEnabled(); 
    if (!serviceEnabled) { 
      return Future.error('Location services are disabled.'); 
    } 
    permission = await Geolocator.checkPermission(); 
    if (permission == LocationPermission.denied) { 
      permission = await Geolocator.requestPermission(); 
      if (permission == LocationPermission.denied) { 
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false; 
      } 
    }
    if (permission == LocationPermission.deniedForever) { 
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    } 
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(_position.latitude);
    print(_position.longitude);
    return true;
    //return await Geolocator.getCurrentPosition();
  }
}
