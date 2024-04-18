import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/create_inspection.dart';
import 'package:syta_admin/screens/add_inspection.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:syta_admin/screens/inspection_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInspections extends StatefulWidget {
  const CheckInspections({super.key});

  @override
  State<CheckInspections> createState() => _CheckInspectionsState();
}

class _CheckInspectionsState extends State<CheckInspections> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String carName = "";
  String userName = "";

  Future<void> getCarName(carId) async {
    try {
      final docRef = _firebaseFirestore.collection("cars").doc(carId);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        final carData = doc.data() as Map<String, dynamic>;
        carName = carData['name'];
        print("Nombre del carro: $carName");

        // Aquí puedes continuar con el resto del código que depende de carName
      } else {
        print("El documento no existe");
      }
    } catch (e) {
      print("Error obteniendo el documento: $e");
    }
  }

  Future<void> getUserName(userId) async {
    try {
      final docRef = _firebaseFirestore.collection("users").doc(userId);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        final carData = doc.data() as Map<String, dynamic>;
        userName = carData['name'];
        print("Nombre del usuario: $userName");

        // Aquí puedes continuar con el resto del código que depende de carName
      } else {
        print("El documento no existe");
      }
    } catch (e) {
      print("Error obteniendo el documento: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Lista de Revisiones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [

        ],
      ),
      body: Column(

        children: [
          const SizedBox(height: 20),
          Row(  
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Revisiones en Progreso',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(  
              onPressed: () {
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddInspection(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle),
              color: Colors.blue, 
            ),
            SizedBox(height: 10,),
          ],
        ),
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.collection('inspections').where("locationId", isEqualTo: ap.administratorModel.locationId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error al obtener los datos: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return Text('No hay documentos disponibles');
              }
              List<QueryDocumentSnapshot> inspections = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: inspections.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> inspectionData = inspections[index].data() as Map<String, dynamic>;
                    //Datos de la inspección
                    String inspectionId    = inspections[index].id;
                    String carId           = inspectionData['carId'];
                    String description     = inspectionData['description'];
                    String endDate         = inspectionData['endDate'];
                    String estimatedDate   = inspectionData['estimatedDate'];
                    String locationId      = inspectionData['locationId'];
                    String startDate       = inspectionData['startDate'];
                    String status          = inspectionData['status'];
                    String title           = inspectionData['title'];
                    String userId          = inspectionData['userId'];

                    int milliseconsDate = int.parse(estimatedDate);
                    DateTime startNormalDate = DateTime.fromMillisecondsSinceEpoch(milliseconsDate);
                    String date = "${startNormalDate.year}-${startNormalDate.month.toString().padLeft(2, '0')}-${startNormalDate.day.toString().padLeft(2, '0')}";

                    return FutureBuilder<void>(
                      future: Future.wait([getCarName(carId), getUserName(userId)]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon:  Icon(Icons.car_repair_rounded),
                                  iconSize: 32,
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (!context.mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  InspectionScreen(
                                            inspectionId: inspectionId,
                                            carName: carName
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(carName, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                        Text(userName, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                        Text("Fecha estimada: "+date, style: TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),

          SizedBox(height: 10,),


        ],
      ),
    );
  }
}