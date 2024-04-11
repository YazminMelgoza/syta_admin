import 'dart:convert';

import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syta_admin/screens/home_screen.dart';
import 'package:syta_admin/screens/main_screen.dart';
import 'package:syta_admin/utils/show_snack_bar.dart'; 
import 'package:syta_admin/model/administrator_model.dart';
import 'package:syta_admin/model/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  AdministratorModel? _administratorModel;
  AdministratorModel get administratorModel => _administratorModel!;
  LocationModel? _locationModel;
  LocationModel get locationModel => _locationModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // signin
  void signInWithCredential(BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await getDataFromFirestore();
      await saveUserDataToSP();
      await setSignIn();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // guard the use with a mounted check
      if (!context.mounted) return;
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  // DATABASE OPERTAIONS
  // Future<bool> checkExistingUser() async {
  //   DocumentSnapshot snapshot =
  //       await _firebaseFirestore.collection("users").doc(_uid).get();
  //   if (snapshot.exists) {
  //     print("USER EXISTS");
  //     return true;
  //   } else {
  //     print("NEW USER");
  //     return false;
  //   }
  // }

  // void saveUserDataToFirebase({
  //   required BuildContext context,
  //   required AdministratorModel userModel,
  //   required File profilePic,
  //   required Function onSuccess,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     // uploading image to firebase storage.
  //     await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
  //       userModel.profilePicture = value;
  //       userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
  //       userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
  //       userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
  //     });
  //     _administratorModel = userModel;

  //     // uploading to database
  //     await _firebaseFirestore
  //         .collection("users")
  //         .doc(_uid)
  //         .set(userModel.toMap())
  //         .then((value) {
  //       onSuccess();
  //       _isLoading = false;
  //       notifyListeners();
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     if (!context.mounted) return;
  //     showSnackBar(context, e.message.toString());
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<String> storeFileToStorage(String ref, File file) async {
  //   UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("administrators")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _administratorModel = AdministratorModel(
        name: snapshot['name'] ?? '',
        locationId: snapshot['locationId'] ?? '',
        uid: _firebaseAuth.currentUser!.uid,
      );
      _uid = administratorModel.uid;
      });

    await _firebaseFirestore
        .collection("locations")
        .doc(_administratorModel!.locationId)
        .get()
        .then((DocumentSnapshot snapshot) {
      _locationModel = LocationModel(
        name: snapshot['name'],
        address: snapshot['address'],
        availability: snapshot['availability'],
        phoneNumber: snapshot['phoneNumber'],
        landlineNumber: snapshot['telephoneNumber'],
      );
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("administrator_model", jsonEncode(administratorModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("administrator_model") ?? '';
    _administratorModel = AdministratorModel.fromMap(jsonDecode(data));
    _uid = _administratorModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
