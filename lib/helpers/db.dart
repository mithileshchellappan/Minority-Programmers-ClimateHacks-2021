import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoder/geocoder.dart';

class DB {
  FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<void> addPost(String caption, String id, GeoPoint geoPoint, File img1,
      File img2) async {
      var city_name = await Geocoder.local.findAddressesFromCoordinates(Coordinates(geoPoint.latitude,geoPoint.longitude));
      String user = FirebaseAuth.instance.currentUser.uid;
    Reference reference =
        _storage.ref().child('before').child(id + DateTime.now().toString());
    Reference reference2 =
        _storage.ref().child('after').child(id + DateTime.now().toString());
    UploadTask up1 = reference.putFile(img1);
    UploadTask up2 = reference2.putFile(img2);
    String link1;
    String link2;
    Set<String> dl1 = await up1.then((res) async => {await res.ref.getDownloadURL()});
    Set<String> dl2 = await up2.then((res) async => {await res.ref.getDownloadURL()});
    print(dl1.first );
    print(dl2.first);
    
    String email = FirebaseAuth.instance.currentUser.email;

    FirebaseFirestore.instance.collection("posts").add({
      "post-id": id,
      "caption": caption,
      "location": geoPoint,
      "uid": user,
      "city":city_name.last.toString(),
      "before-pic": dl1.first,
      "after-pic": dl2.first,
    });
    List<dynamic> temp = [];
    String firebaseUser = FirebaseAuth.instance.currentUser.uid;
    print(firebaseUser);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser)
        .get()
        .then((data) {
      temp = data.data()["post-ids"];
      print(temp);
      temp.add(id);
      print(temp);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser)
        .update({"post-ids": temp});
  }
}
