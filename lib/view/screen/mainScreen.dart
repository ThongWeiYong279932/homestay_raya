import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:homestay_raya/view/screen/buyerHomestayDetailScreen.dart';
import 'package:homestay_raya/view/screen/detailScreen.dart';
import 'package:homestay_raya/view/screen/homestayListScreen.dart';

import 'package:homestay_raya/view/screen/loginScreen.dart';
import 'package:homestay_raya/view/screen/newHomestayScreen.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;


import '../../model/homestay.dart';
import '../shared/serverConfig.dart';
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
  List<Homestays> HomestayList = <Homestays>[];
  String titlecenter = "Loading...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var seller;
  //for pagination
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;
//for pagination
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadHomestay("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        appBar: AppBar(title: const Text("Main Screen"), 
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _loadSearchDialog();
              },
            ),
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
        body: HomestayList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Homestay ($numberofresult found)",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: rowcount,
                        children: List.generate(HomestayList.length, (index) {
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                _showDetails(index);
                              },
                              child: Column(children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: resWidth / 2,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${ServerConfig.Server}/Homestay_Raya/assets/images/homestay/${HomestayList[index].homestayId}.png",
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
                                  Text("Name: ${HomestayList[index].homestayName}", overflow: TextOverflow.ellipsis,),
                                  Text("Price: RM${HomestayList[index].homestayPrice}"),
                                  Text("Deposit: RM${HomestayList[index].homestayDeposit}"),
                                  Text("Room No: ${HomestayList[index].homestayRoomno}"),
                                  Text("Location: ${HomestayList[index].homestayState}, ${HomestayList[index].homestayLocal}"),
                                ],
                              )),
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                    //pagination widget
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          //build the list for textbutton with scroll
                          if ((curpage - 1) == index) {
                            //set current page number active
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return TextButton(
                              onPressed: () =>
                                  {_loadHomestay(search, index + 1)},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        },
                      ),
                    ),
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
  
  void _loadHomestay(String search, int pageno) {
    curpage = pageno; //init current page
    numofpage ?? 1; //get total num of pages if not by default set to only 1

    http.get(
      Uri.parse("${ServerConfig.Server}/Homestay_Raya/php/loadallhomestays.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
      progressDialog.show();
      //print(response.body);
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata = jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array

          if (extractdata['homestays'] != null) {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata[
                'numberofresult']); //get total number of result returned
            //check if  array object is not null
            HomestayList = <Homestays>[]; //complete the array object definition
            extractdata['homestays'].forEach((v) {
              //traverse products array list and add to the list object array productList
              HomestayList.add(Homestays.fromJson(
                  v)); //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No homestay Available"; //if no data returned show title center
            HomestayList.clear();
          }
        }
      } else {
        titlecenter = "No Homestay Available"; //status code other than 200
        HomestayList.clear(); //clear productList array
      }

      setState(() {}); //refresh UI
      progressDialog.dismiss();
    });
  }
  
  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadHomestay(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }
  
  //May need Modification later.
  void _showDetails(int index) {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Homestays homestay = Homestays.fromJson(HomestayList[index].toJson());
    loadSingleSeller(index);
    //todo update seller object with empty object.
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      if (seller != null) {
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => buyerHomestayDetailScreen(
                      user: widget.user,
                      homestay: homestay,
                      seller: seller,
                    )));
      }
      progressDialog.dismiss();
    });
  }
  
  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
  
  void loadSingleSeller(int index) {
    http.post(Uri.parse("${ServerConfig.Server}/Homestay_Raya/php/load_seller.php"),
        body: {"sellerid": HomestayList[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        seller = User.fromJson(jsonResponse['data']);
      }
    });
  }
}
