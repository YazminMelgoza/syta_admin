import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/check_inspections.dart';
import 'package:syta_admin/screens/home_screen.dart';
import 'package:syta_admin/screens/inspection_detail_screen.dart';
import 'package:syta_admin/screens/inspection_Adddetail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionScreen extends StatefulWidget {
  final String inspectionId;
  final String carName;
  const InspectionScreen({super.key,required this.inspectionId, required this.carName});


  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isChecked = false;
  void actualizarEstatus( String id, String status, String dateF)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "endDate": dateF});
  }
  void finalizarInspeccion( String id, String statusIns)
  {
    _firebaseFirestore.collection("inspections").doc(id).update({"status": statusIns});
  }
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Revisión", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckInspections(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(width: 10),
          Container(
        margin:EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.carName,textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20, // Tamaño del título
                fontWeight: FontWeight.bold, // Negrita para un aspecto de título

              ),
            ),

          ],
        ),
      ),

      SizedBox(width: 10),
      StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection('inspectionDetails').where("inspectionId", isEqualTo: widget.inspectionId).snapshots(),
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError)
          {
            return Text('Error al obtener los datos: ${snapshot.error}');
          }
          if (!snapshot.hasData)
          {
            return Text('No hay documentos disponibles');
          }
          List<QueryDocumentSnapshot> users = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
                String documentId = users[index].id;
                String userStatus = userData['status'];
                String endDate = "";
                int milliseconsDate = int.parse(userData['startDate']);
                DateTime startNormalDate = DateTime.fromMillisecondsSinceEpoch(milliseconsDate);
                String startDate = startNormalDate.toString();
                //Date in millisecons
                if(userData['status']=="FINALIZADO"){
                  int fechaEnMilisegundos = int.parse(userData['endDate']); // Por ejemplo, 1617948600000 representa el 09 de abril de 2021
                  DateTime fechaNormal = DateTime.fromMillisecondsSinceEpoch(fechaEnMilisegundos);
                  endDate = fechaNormal.toString();
                }


                return Center(
                  child: Container(
                    //width: 200,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (userStatus=="FINALIZADO") ? Colors.blue[50] : Colors.orangeAccent, // Color de fondo del Container
                      borderRadius: BorderRadius.circular(10), // Radio de borde del Container
                    ),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                            String dateF = "";
                            String status = "";
                            if (userData['status']=="EN PROGRESO")
                            {
                              status = "FINALIZADO";
                              DateTime now = DateTime.now();
                              dateF = now.millisecondsSinceEpoch.toString();
                            }else
                            {
                              status = "EN PROGRESO";
                            }
                            actualizarEstatus(documentId,status, dateF);

                          },
                          icon: (userStatus=="FINALIZADO") ? Icon(Icons.check_circle) : Icon(Icons.check_circle_outline),
                          iconSize: 32,
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InspectionDetailScreen(
                                      inspectionDetailId: documentId,
                                      description: userData['description'],
                                      endDate: endDate,
                                      startDate: startDate,
                                      status: userData['status']
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Text(userData['description'],
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                  Text(endDate, style: TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  InspectionAddDetailScreen(
                  inspectionId: widget.inspectionId
              ),
            ),
          );


        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFC4C00),
        ),
        child: Text(
          "Agregar Actualización",
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  CheckInspections(),
            ),
          );
          finalizarInspeccion(widget.inspectionId, "FINALIZADO");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 9, 8, 99),
        ),
        child: Text(
          "Finalizar Revisión",
          style: TextStyle(color: Colors.white),
        ),
      ),
              ],
            ),
    );
  }
}

