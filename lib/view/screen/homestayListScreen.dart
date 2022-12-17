import 'package:flutter/material.dart';
import 'package:homestay_raya/model/user.dart';

import 'mainScreen.dart';
import 'profileScreen.dart';

class HomestayListScreen extends StatefulWidget {
  final User user;
  const HomestayListScreen({super.key, required this.user});

  @override
  State<HomestayListScreen> createState() => _HomestayListScreenState();
}

class _HomestayListScreenState extends State<HomestayListScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Homestay List")),
        body: const Center(
          child: Text("Homestay List"),
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