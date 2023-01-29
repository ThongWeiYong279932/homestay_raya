import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/model/homestay.dart';
import 'package:http/http.dart' as http;

import '../shared/serverConfig.dart';
import 'detailScreen.dart';
import 'mainScreen.dart';
import 'profileScreen.dart';

class HomestayListScreen extends StatefulWidget {
  final User user;
  const HomestayListScreen({super.key, required this.user});

  @override
  State<HomestayListScreen> createState() => _HomestayListScreenState();
}

class _HomestayListScreenState extends State<HomestayListScreen> {
  List<Homestays> homestayList = <Homestays>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _loadHomestay();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("User Homestay List")),
        body: homestayList.isEmpty
        ? Center( 
            child: Text(
              titlecenter, 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))) 
        : Column( 
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: rowcount,
                  children: List.generate(homestayList.length, (index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                            _showDetails(index);
                        },
                        onLongPress: () {
                            _deleteDialog(index);
                        },
                        child: Column(
                          children: [
                            Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      width: resWidth/2,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${ServerConfig.Server}/Homestay_Raya/assets/images/homestay/${homestayList[index].homestayId}.png",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                            ),
                            Flexible(
                              flex: 6,
                              child: Column(
                                children: [
                                  Text("Name: ${homestayList[index].homestayName}", overflow: TextOverflow.ellipsis,),
                                  Text("Price: RM${homestayList[index].homestayPrice}"),
                                  Text("Deposit: RM${homestayList[index].homestayDeposit}"),
                                  Text("Room No: ${homestayList[index].homestayRoomno}"),
                                  Text("Location: ${homestayList[index].homestayState}, ${homestayList[index].homestayLocal}"),
                                ],
                              )),
                          ]),
                      ),
                    );
                  }),
                ))
            ], 
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
  
  void _loadHomestay() {
    if (widget.user.id == "0") {
      //check if the user is registered or not
      Fluttertoast.showToast(
          msg: "Please register an account first", //Show toast
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
          titlecenter = "Please register an account";
          setState(() {
            
          });
      return; //exit method if true
    }
    //if registered user, continue get request
    http.get(
      Uri.parse(
          "${ServerConfig.Server}/Homestay_Raya/php/loadUserHomestay.php?userid=${widget.user.id}"),
    )
        .then((response) {
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata = jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['homestays'] != null) {
            //check if  array object is not null
            homestayList = <Homestays>[]; //complete the array object definition
            extractdata['homestays'].forEach((v) {
              //traverse homestays array list and add to the list object array homestayList
              homestayList.add(Homestays.fromJson(
                  v)); //add each homestay array to the list object array homestayList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Homestay Available"; //if no data returned show title center
            homestayList.clear();
          }
        } else {
          titlecenter = "No Homestay Available";
        }
      } else {
        titlecenter = "No Homestay Available"; //status code other than 200
        homestayList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
  }
  
  Future<void> _showDetails(int index) async {
    Homestays homestay = Homestays.fromJson(homestayList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => detailScreen(
                  homestay: homestay,
                  user: widget.user,
                )));
    _loadHomestay();
  }
  
  void _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(homestayList[index].homestayName.toString(), 15)}",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteHomestay(index);
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

  void _deleteHomestay(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.Server}/Homestay_Raya/php/delete_homestay.php"),
      body: {
        "homestayid": homestayList[index].homestayId,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadHomestay();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
  
  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
  
}