import 'package:flutter/material.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/view/screen/homestayListScreen.dart';


import 'mainScreen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: const Center(
          child: Text("Profile"),
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
                  MaterialPageRoute(builder: (content) => MainScreen(user: widget.user)));
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
}