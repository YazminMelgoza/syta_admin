import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Use alias for clarity
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart'; // Assuming this is where getDocReferenceForCurrentUser resides
import 'package:syta_admin/screens/login_screen.dart';
import 'package:provider/provider.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

class UpdateAvail extends StatefulWidget {
  const UpdateAvail({super.key});

  @override
  State<UpdateAvail> createState() => _UpdateAvail();
}

class _UpdateAvail extends State<UpdateAvail> {
  String _status = "medium";
  DocumentReference<
      Map<String, dynamic>>? _locationRef; // Store location reference

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    final sytaAp = Provider.of<AuthProvider>(
        context, listen: false); // Access AuthProvider
    final userDocRef = sytaAp
        .getDocReferenceForCurrentUser(); // Get user doc reference

    if (userDocRef != null) {
      final userDocSnap = await userDocRef.get();
      if (userDocSnap.exists) {
        final locationId = userDocSnap.data()?['locationId'];
        if (locationId != null) {
          _locationRef = FirebaseFirestore.instance.collection('locations').doc(
              locationId);
          final locationSnap = await _locationRef?.get();
          if (locationSnap!.exists) {
            setState(() {
              _status = locationSnap.data()?['availability'];
            });
          } else {
            print("Error: Location document not found for ID: $locationId");
          }
        } else {
          print("Error: 'locationId' field not found in user document.");
        }
      } else {
        print("Error: User document not found.");
      }
    } else {
      print("Error: Unable to get document reference for current user.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final docRef = FirebaseFirestore.instance.collection('locations').doc(
        '7yGA1qlf3PoEYOzHQxUf');
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: Text("SYTA  ${ap.locationModel.name}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15, top: 20),
                    child:
                    Text("Disponibilidad",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 12),
                        child:
                        ElevatedButton(
                          onPressed: () => _updateStatus("low"),
                          child: Text(""),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 200,
                        child: Text("La sucursal puede aceptar inspecciones",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500
                            )
                        ),)
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 12), child:
                      ElevatedButton(
                        onPressed: () => _updateStatus("medium"),
                        child: Text(""),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.all(15),
                        ),
                      ), // Add some space between the button
                      ),
                      SizedBox(
                          width: 200,
                          child:
                          Text("La sucursal ofrece pocas inspecciones",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500))
                      )

                    ],
                  ),
                  SizedBox(height: 30
                  ),
                  Row(children: [
                    Padding(padding: EdgeInsets.only(left: 12), child:
                    ElevatedButton(
                      onPressed: () => _updateStatus("high"),
                      child: Text(""),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                    ),
                    SizedBox(
                        width: 200,
                        child: Text("La sucursal no acepto inspecciones",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500))
                    )

                  ],)
                ],
              ),
              SizedBox(height: 80),
              Row(children: [
                Padding(padding: EdgeInsets.only(left: 20), child:
                Text("Estado Actual de la sucursal:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))
                ),
                SizedBox(width: 15),
                _buildStatusIndicator(_status)
              ],

              )
            ],
          )),
    );
  }

  Widget _statusButton(String label, Color color, Function onPressed) {
    return ElevatedButton(
      onPressed: onPressed(),
      child: Text(label),
      style: ElevatedButton.styleFrom(
        //primary: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  _updateStatus(String newStatus) async {
    final sytaAp = Provider.of<AuthProvider>(
        context, listen: false); // Access AuthProvider
    final userDocRef = sytaAp
        .getDocReferenceForCurrentUser(); // Get user doc reference

    if (userDocRef != null) {
      final userDocSnap = await userDocRef.get();
      if (userDocSnap.exists) {
        final locationId = userDocSnap.data()?['locationId'];
        if (locationId != null) {
          _locationRef = FirebaseFirestore.instance.collection('locations').doc(
              locationId);
          final locationSnap = await _locationRef?.get();
          _locationRef?.update({'availability': newStatus});
          setState(() {
            _status = newStatus;
          });

          // TODO: Call your Firebase function to update the status in the database
        }
      }
    }
  }

  Widget _buildStatusIndicator(String _status) {
    Color statusColor;
    switch (_status) {
      case "high":
        statusColor = Colors.red;
        break;
      case "medium":
        statusColor = Colors.yellow;
        break;
      case "low":
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey; // Handle default or loading state
    }

    return CircleAvatar(
      backgroundColor: statusColor,
      radius: 20, // Adjust size as needed
    );
  }
}