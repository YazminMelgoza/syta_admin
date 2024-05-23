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


  Future<String> getCarName(carId) async {
    try {
      final docRef = _firebaseFirestore.collection("cars").doc(carId);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        final carData = doc.data() as Map<String, dynamic>;
        carName = carData['name']!;
      } else {
        print("El documento no existe");
        carName = "No carro";
      }
      return carName;
    } catch (e) {
      print("Error obteniendo el documento: $e");
      carName = "Error";
      return carName;
    }
  }

  Future<String> getUserName(userId) async {
    try {
      final docRef = _firebaseFirestore.collection("users").doc(userId);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        final carData = doc.data() as Map<String, dynamic>;
        userName = carData['name'];

      } else {
        print("El documento no existe");
        userName = "No name";
      }
      return userName;
    } catch (e) {
      print("Error obteniendo el documento: $e");
      userName = "Error";
      return userName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Lista de Revisiones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            stream: _firebaseFirestore.collection('inspections')
              .where("locationId", isEqualTo: ap.administratorModel.locationId)
              .where("status", isEqualTo: "EN PROGRESO")
              .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error al obtener los datos: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Text('No hay documentos disponibles');
              }

              List<QueryDocumentSnapshot> inspections = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: inspections.length,
                  itemBuilder: (context, index)
                  {
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

                    String userName = userId;
                    String carName =  carId;

                    // Obtener el nombre del carro (carName) utilizando el carId
                    Future<String> getCarName(String carId) async {
                      DocumentSnapshot carSnapshot = await _firebaseFirestore.collection('cars').doc(carId).get();
                      return carSnapshot.get('name');
                    }

                    // Obtener el nombre del usuario (userName) utilizando el userId
                    Future<String> getUserName(String userId) async {
                      DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(userId).get();
                      return userSnapshot.get('name');
                    }

                    return FutureBuilder(
                      future: Future.wait([
                        getCarName(carId),
                        getUserName(userId),
                      ]),
                      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
                        }
                        if (snapshot.hasError) {
                          return Text('Error al obtener los datos: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return Text('No hay datos disponibles');
                        }

                        String carName = snapshot.data![0]; // Obtiene el nombre del carro
                        String userName = snapshot.data![1]; // Obtiene el nombre del usuario

                        // Ahora puedes usar carName y userName en tu UI
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.car_repair_rounded),
                                  iconSize: 32,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!context.mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>  InspectionScreen(
                                            inspectionId: inspections[index].id,
                                            carName: carName,
                                  
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(inspectionData['title'], style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                          Text(carName, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                          Text(userName, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                          Text("Fecha estimada: ${inspectionData['estimatedDate']}", style: TextStyle(fontSize: 12),textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 1,),
                                        ],
                                      ),
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
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}