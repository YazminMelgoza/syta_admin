import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/check_inspections.dart';
import 'package:syta_admin/screens/home_screen.dart';
import 'package:syta_admin/screens/inspection_detail_screen.dart';
import 'package:syta_admin/screens/inspection_Adddetail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syta_admin/screens/main_screen.dart';

class InspectionScreenView extends StatefulWidget {
  final String inspectionId;
  final String carName;
  const InspectionScreenView({super.key,required this.inspectionId, required this.carName});


  @override
  State<InspectionScreenView> createState() => _InspectionScreenViewState();
}

class _InspectionScreenViewState extends State<InspectionScreenView> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isChecked = false;
  void actualizarEstatus( String id, String status, String dateF)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "endDate": dateF});
  }


  void finalizarInspeccion(BuildContext context, String id, String statusIns)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar finalización"),
          content: const Text("¿Estás seguro de que quieres finalizar esta revisión?, El cliente sabrá que ya puede pasar por su automovil"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Actualiza la inspección y cierra la pantalla
                String currentTimeInMillis = DateTime.now().millisecondsSinceEpoch.toString();
                _firebaseFirestore.collection("inspections").doc(id).update(
                    {
                      "status": statusIns,
                      "endDate": currentTimeInMillis
                    }
                );
                Navigator.pop(context); // Cierra la pantalla actual
                Navigator.pop(context); // Cierra la ventana modal
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Detalle de Revisión", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ), (route) => false);
            },
            icon: const Icon(Icons.home, color: Colors.white),
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


                          },
                          icon: (userStatus=="FINALIZADO") ? Icon(Icons.check_circle) : Icon(Icons.check_circle_outline),
                          iconSize: 32,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userData['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                    Text(endDate, overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 15),),
                                  ],
                                ),
                              )
                          ),
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

      SizedBox(height: 20),

              ],
            ),
    );
  }
}

