import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:provider/provider.dart';

class UpdateAvail extends StatefulWidget {
  const UpdateAvail({super.key});

  @override
  State<UpdateAvail> createState() => _UpdateAvail();
}

class _UpdateAvail extends State<UpdateAvail> {
  String _status = "medium";
  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    final docRef = FirebaseFirestore.instance.collection('locations').doc('7yGA1qlf3PoEYOzHQxUf');
    final docSnap = await docRef.get();
    setState(() {
      _status = docSnap.data()?['availability'];
    });
  }
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final docRef = FirebaseFirestore.instance.collection('locations').doc('7yGA1qlf3PoEYOzHQxUf');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("SYTA  ${ap.locationModel.name}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
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
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15,top: 20),
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
                      Text("La sucursal puede aceptar inspecciones",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500
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
                      Text("La sucursal ofrece pocas inspecciones",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))

                    ],
                  ),
                  SizedBox(height: 30
                  ),
                  Row(children: [
                    Padding(padding: EdgeInsets.only(left: 12),child:
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
                    Text("La sucursal no acepto inspecciones",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))

                  ],)
                ],
              ),
              SizedBox(height: 80),
              Row(children: [
                Padding(padding: EdgeInsets.only(left: 20),child:
                Text("Estado Actual de la sucursal:",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500))
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

  _updateStatus(String newStatus) {
    final docRef = FirebaseFirestore.instance.collection('locations').doc('7yGA1qlf3PoEYOzHQxUf');
    docRef.update({'availability': newStatus});
    setState(() {
      _status = newStatus;
    });

    // TODO: Call your Firebase function to update the status in the database
  }}

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
