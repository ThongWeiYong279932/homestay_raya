import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/view/screen/homestayListScreen.dart';
import 'package:homestay_raya/view/shared/serverConfig.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../../model/user.dart'; 

class newHomestayScreen extends StatefulWidget {
  final User user;
  final Position position;
  const newHomestayScreen(
      {super.key,
      required this.user,
      required this.position,
      });

  @override
  State<newHomestayScreen> createState() => _newHomestayScreenState();
}

class _newHomestayScreenState extends State<newHomestayScreen> {
  final TextEditingController _hsnameEditingController = TextEditingController();
  final TextEditingController _hsdescEditingController = TextEditingController();
  final TextEditingController _hspriceEditingController = TextEditingController();
  final TextEditingController _hsdepositEditingController = TextEditingController();
  final TextEditingController _hsroomEditingController = TextEditingController();
  final TextEditingController _hsstateEditingController = TextEditingController();
  final TextEditingController _hslocalEditingController = TextEditingController();
  var _lat, _lng;
  @override
  void initState(){
    super.initState();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    _getAddress();
  }

  File? _image; 
  var pathAsset = "assets/image/Image Icon.png";
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Homestay"),), 
      body: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
            onTap: _selectImageDialog,
          child: Card(
            elevation: 8,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _image == null
                    ? AssetImage(pathAsset)
                    : FileImage(_image!) as ImageProvider,
                  fit: BoxFit.scaleDown, 
                ),
              ),
            ),
          ),),
          const Text( 
            "Add New Homestay", 
            style: TextStyle(  
                  fontSize: 24, 
                  fontWeight: FontWeight.w600, 
            ), 
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey, 
              child: Column(children: [
              TextFormField( textInputAction: TextInputAction.next, 
              validator: (val) => val!.isEmpty || (val.length < 3) 
       	        ? "Homestay name must be longer than 3" 
                  : null,
                controller: _hsnameEditingController,   
                keyboardType: TextInputType.text, 
                decoration: const InputDecoration( 
                labelText: 'Homestay Name', 
                labelStyle: TextStyle( 
      	      ), 
                icon: Icon(Icons.person), 
                focusedBorder: OutlineInputBorder( 
       	      borderSide: BorderSide( 
                width: 2.0), 
   	 	        ) 
              )),
              TextFormField( textInputAction: TextInputAction.next, 
                validator: (val) => val!.isEmpty || (val.length < 10) 
       	        ? "Homestay description must be longer than 10" 
                  : null, 
              maxLines: 4,
              controller: _hsdescEditingController,  
              keyboardType: TextInputType.text, 
              decoration: const InputDecoration( 
       	    labelText: 'Homestay Description', 
              alignLabelWithHint: true, 
              labelStyle: TextStyle(), 
              icon: Icon(Icons.person,), 
              focusedBorder: OutlineInputBorder( 
       	    borderSide: BorderSide(width: 2.0),))),
              Row( 
                children: [ 
                  Flexible( 
                  flex: 5, 
                  child: TextFormField( 
                    textInputAction: TextInputAction.next, 
                    validator: (val) => val!.isEmpty
       	            ? "Homestay price must contain value" 
                      : null, 
                    controller: _hspriceEditingController,
                    keyboardType: TextInputType.number,  
                    decoration: const InputDecoration( 
        	        labelText: 'Price/day', 
                    labelStyle: TextStyle( 
                    ), 
                    icon: Icon(Icons.money), 
                    focusedBorder: OutlineInputBorder( 
        	        borderSide: BorderSide( 
        	 	        width: 2.0),)) 
  	            ),), 
                  Flexible( 
                  flex: 5, 
                  child: TextFormField( 
                    textInputAction: TextInputAction.next, 
                    validator: (val) => val!.isEmpty 
        	          ? "Room Number should be more than 0" 
                      : null,
                    controller: _hsroomEditingController,
                    keyboardType: TextInputType.number, 
                    decoration: const InputDecoration( 
        	        labelText: 'Room Number', 
                    labelStyle: TextStyle(), 
                    icon: Icon(Icons.house), 
                    focusedBorder: OutlineInputBorder( 
        	        borderSide: BorderSide(
                      width: 2.0), 
  	              )) 
                  ),), 
                ], 
              ),
              Row(
                    children: [
                      Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _hsstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current States',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _hslocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      )
                    ],
                  ),
              Row(children: [ 
                Flexible( 
                  flex: 5, 
                  child: TextFormField( 
        	        textInputAction: TextInputAction.next, 
                    validator: (val) => val!.isEmpty 
               	      ? "Must be more than zero" 
                      : null,
                    controller: _hsdepositEditingController,
                    keyboardType: TextInputType.number, 
                    decoration: const InputDecoration( 
                    labelText: 'Deposit', 
                    labelStyle: TextStyle(), 
                    icon: Icon(Icons.money), 
                    focusedBorder: OutlineInputBorder( 
                    borderSide: BorderSide(width: 2.0), 
                    ))),),
                Flexible( 
        	      flex: 5, 
                  child: CheckboxListTile( 
                    title: const Text("Lawfull Homestay?"),
                    value: _isChecked, //    <‐‐ label              value: _isChecked, 
                    onChanged: (bool? value) { 
               	    setState(() { 
                       	_isChecked = value!; 
                    }); 
                    }, 
	  	          )), 
              ]),
              SizedBox(
                width: 200,
                child: ElevatedButton(  
                  child: const Text('Add Homestay'), 
                    onPressed: () => {
        	        _newHomestayDialog(), }, 
                ),
              ), 
            ]),),
          )
        ]),
      )
    );
  }
  
  _newHomestayDialog() {
    if (_image == null) { 
      Fluttertoast.showToast( 
          msg: "Please take the product picture", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0); 
      return; 
    }
    if (!_formKey.currentState!.validate()) { 
      Fluttertoast.showToast( 
          msg: "Please fill in all the required fields", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          fontSize: 14.0); 
  	    return; 
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please check agree checkbox",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please check agree checkbox",
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
            "Insert this Homestay?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertHomestay();
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

  void _selectImageDialog() {
    showDialog( 
      context: context, 
      builder: (BuildContext context) {         // return object of type Dialog 
        return AlertDialog( 
            title: const Text( 
              "Select image from", 
              style: TextStyle(), 
            ), 
            content: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                IconButton(
                  iconSize: 32,
                  onPressed: _onCamera, icon: const Icon(Icons.camera)),
                IconButton(
                  iconSize: 32,
                  onPressed: _onGallery, icon: const Icon(Icons.browse_gallery)),
   	 	        ], 
            )); 
      }, 
    ); 
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker(); 
    final pickedFile = await picker.pickImage( 
      source: ImageSource.camera, 
      maxHeight: 800, 
      maxWidth: 800, 
    ); 
    if (pickedFile != null) { 
      _image = File(pickedFile.path); 
      _cropImage();
      setState(() {});
    } else { 
      print('No image selected.'); 
    } 
  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker(); 
    final pickedFile = await picker.pickImage( 
      source: ImageSource.gallery, 
      maxHeight: 800, 
      maxWidth: 800, 
    ); 
    if (pickedFile != null) { 
      _image = File(pickedFile.path); 
      _cropImage();
      setState(() {});
    } else { 
      print('No image selected.'); 
    } 
  }

  Future<void> _cropImage() async{
    CroppedFile? croppedFile = await ImageCropper().cropImage( 
    sourcePath: _image!.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop', 
        toolbarColor: Colors.deepOrange, 
        toolbarWidgetColor: Colors.white, 
        initAspectRatio: CropAspectRatioPreset.original, 
        lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) { 
      File imageFile = File(croppedFile.path);
      _image = imageFile; 
      setState(() {}); 
    }
  }

  //void _checkGetLocPermission() async {
  //  bool serviceEnabled; 
  //  LocationPermission permission; 
  //  serviceEnabled = await Geolocator.isLocationServiceEnabled(); 
  //  if (!serviceEnabled) { 
  //    return Future.error('Location services are disabled.'); 
  //  } 
  //  permission = await Geolocator.checkPermission(); 
  //  if (permission == LocationPermission.denied) { 
  //    permission = await Geolocator.requestPermission(); 
  //    if (permission == LocationPermission.denied) { 
  //      return Future.error('Location permissions are denied'); 
  //    } 
  //  }
  //  if (permission == LocationPermission.deniedForever) { 
  //    return Future.error('Location permissions are permanently denied.');
  //  } 
  //  _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //  print(_position.latitude);
  //  print(_position.longitude);
  //  _getAddress(_position);
    //return await Geolocator.getCurrentPosition();
  //}

  _getAddress() async { 
    List<Placemark> placemarks = 
        await placemarkFromCoordinates(widget.position.latitude, widget.position.longitude); 
    setState(() {
      _hsstateEditingController.text = placemarks[0].administrativeArea.toString();
      _hslocalEditingController.text = placemarks[0].locality.toString();
      String loc = "${placemarks[0].locality},${placemarks[0].administrativeArea},${placemarks[0].country}"; 
      print(loc);
      //_prstateEditingController.text = placemarks[0].administrativeArea.toString(); 
      //prlat = _currentPosition.latitude.toString(); 
      //prlong = _currentPosition.longitude.toString(); 
    }); 
  }
  
  void insertHomestay() {
    String hsname = _hsnameEditingController.text;
    String hsdesc = _hsdescEditingController.text;
    String hsprice = _hspriceEditingController.text;
    String deposit = _hsdepositEditingController.text;
    String roomno = _hsroomEditingController.text;
    String state = _hsstateEditingController.text;
    String local = _hslocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${ServerConfig.Server}/Homestay_Raya/php/insert_homestay.php"), 
    body: {
      "userid": widget.user.id,
      "hsname": hsname,
      "hsdesc": hsdesc,
      "hsprice": hsprice,
      "deposit": deposit,
      "roomno": roomno,
      "state": state,
      "local": local,
      "lat": _lat,
      "lon": _lng,
      "image": base64Image
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        Navigator.push(context, 
                  MaterialPageRoute(builder: (content) => HomestayListScreen(user: widget.user)));
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
  }
}