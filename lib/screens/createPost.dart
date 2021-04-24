import 'dart:async';
import 'dart:io';

import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:platform_action_sheet/platform_action_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trashgram/helpers/db.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

Position _currPos;
String caption;
String _mapStyle;

class _CreatePostState extends State<CreatePost> {
  File _image;
  File _image2;
  TextEditingController textEditingController;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  @override
  void initState() {
    // TODO: implement initState
    rootBundle.loadString('assets/map_style.txt').then((value) {
      _mapStyle = value;
    });
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Set<Marker> mark;
  Future<BitmapDescriptor> getImg() async {
    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/pin.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          'Trashgram',
          style: TextStyle(
              color: Colors.white, fontSize: 42, fontFamily: "Billabong"),
        ),
        backgroundColor: Color(0xFFF191720),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldUi(
              context: context,
              hint: "Enter your caption",
              textControl: textEditingController,
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Location cleaned by you:')),
            SizedBox(height: 10),
            // Container(
            //   height: 250,
            //   child: googleMap(snapshot),
            // ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    openSheet(isAfter: true);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(4),
                    padding: EdgeInsets.all(6),
                    child: _image == null
                        ? Center(
                            child: Column(
                              children: [
                                Image.asset('assets/waste.png',
                                    width: 150, height: 150),
                                Text('Add before picture'),
                              ],
                            ),
                          )
                        : Image.file(
                            _image,
                            width: 150,
                            height: 200,
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: () => openSheet(isAfter: false),
                  child: DottedBorder(
                      child: _image2 == null
                          ? Column(children: [
                              Image.asset(
                                'assets/remove.png',
                                width: 150,
                                height: 150,
                              ),
                              Text('Add after picture')
                            ])
                          : Image.file(_image2, width: 150, height: 200),
                      borderType: BorderType.RRect,
                      radius: Radius.circular(4),
                      padding: EdgeInsets.all(6)),
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * .75,
              child: RoundedLoadingButton(
                controller: _btnController,
                color: Color(0xFFF191720),
                valueColor: Colors.white,
                onPressed: () async {
                  try {
                    Position latlng = await determinePosition();
                    await DB().addPost(
                        caption,
                        DateTime.now().toString(),
                        GeoPoint(latlng.latitude, latlng.longitude),
                        _image,
                        _image2);
                    _btnController.success();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(40),
                        content: Text("Post Created")));
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(40),
                        content:
                            Text("Something went wrong. Please try again")));
                    _btnController.reset();
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    height: 49,
                    // width: double.infinity,
                    width: MediaQuery.of(context).size.width * .75,
                    decoration: BoxDecoration(
                      color: Color(0xFFF191720),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text("Post",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // child: FutureBuilder(
        //     future: Future.wait([Geolocator.getCurrentPosition(), getImg()]),
        //     builder: (context, snapshot) {
        //       switch (snapshot.connectionState) {
        //         case ConnectionState.waiting:
        //           return Center(child: lt.Lottie.asset('assets/loading.json'));
        //         case ConnectionState.done:
        //           return mainWidget(snapshot);
        //         default:
        //           return Text('error');
        //       }
        //     }),
      ),
    );
  }

  // Widget mainWidget(AsyncSnapshot<List<dynamic>> snapshot) {
  //   return SingleChildScrollView(
  //     child:
  //   );
  // }

  void openSheet({bool isAfter}) {
    PlatformActionSheet().displaySheet(context: context, actions: [
      ActionSheetAction(
        text: "Take Picture",
        onPressed: () => getImage(ImageSource.camera, context, isAfter),
      ),
      ActionSheetAction(
        text: "Choose picture from gallery",
        onPressed: () => getImage(ImageSource.gallery, context, isAfter),
      ),
    ]);
  }

  Future getImage(
      ImageSource source, BuildContext context, bool isAfter) async {
    final result = await ImagePicker.platform.pickImage(source: source);
    Navigator.pop(context);
    if (result != null) {
      print("file picked");
      File file = File(result.path);
      if (isAfter) {
        setState(() {
          _image = file;
        });
      } else {
        setState(() {
          _image2 = file;
        });
      }
    }
  }

  Widget googleMap(AsyncSnapshot<List<dynamic>> snapshot) {
    return GoogleMap(
      mapType: MapType.normal,
      scrollGesturesEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        controller.setMapStyle(_mapStyle);
      },
      markers: {
        Marker(
            position:
                LatLng(snapshot.data[0].latitude, snapshot.data[0].longitude),
            icon: snapshot.data[1],
            markerId: MarkerId('01'))
      },
      initialCameraPosition: CameraPosition(
        zoom: 19.15,
        target: LatLng(snapshot.data[0].latitude, snapshot.data[0].longitude),
      ),
    );
  }
}

class TextFieldUi extends StatelessWidget {
  const TextFieldUi({
    Key key,
    @required this.textControl,
    @required this.hint,
    @required this.context,
  }) : super(key: key);
  final String hint;
  final TextEditingController textControl;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .9,
        height: 54,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF313039), width: 3),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (val) {
                caption = val;
              },
              controller: textControl,
              validator: (val) {},
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "",
                  contentPadding: EdgeInsets.all(8),
                  hintStyle: TextStyle(
                      color: Color(0xFFF7c7d89), fontWeight: FontWeight.bold)),
            )));
  }
}
