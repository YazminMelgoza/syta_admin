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
        carName = "No carro";
      }
      return carName;
    } catch (e) {
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
        userName = "No name";
      }
      return userName;
    } catch (e) {
      userName = "Error";
      return userName;
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
        title: const Text(
          "Lista de Revisiones",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              const SizedBox(height: 10),
              
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore
                .collection('inspections')
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
                  itemBuilder: (context, index) {
                    Map<String, dynamic> inspectionData = inspections[index].data() as Map<String, dynamic>;
                    String inspectionId = inspections[index].id;
                    String carId = inspectionData['carId'];
                    String userId = inspectionData['userId'];
                    String estimatedDate = inspectionData['estimatedDate'];
                    String title = inspectionData['title'];

                    int millisecondsDate = int.parse(estimatedDate);
                    DateTime normalDate = DateTime.fromMillisecondsSinceEpoch(millisecondsDate);
                    String date = "${normalDate.year}-${normalDate.month.toString().padLeft(2, '0')}-${normalDate.day.toString().padLeft(2, '0')}";

                    return FutureBuilder(
                      future: Future.wait([
                        getCarName(carId),
                        getUserName(userId),
                      ]),
                      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text('Error al obtener los datos: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const Text('No hay datos disponibles');
                        }

                        String carName = snapshot.data![0];
                        String userName = snapshot.data![1];

                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InspectionScreen(
                                    inspectionId: inspectionId,
                                    carName: carName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 3,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              userName,
                                              style: const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Auto: $carName",
                                              style: const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Fecha Estimada: $date",
                                              style: const TextStyle(fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        children: const [
                                          Icon(
                                            Icons.directions_car,
                                            size: 24,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "En Curso",
                                            style: TextStyle(fontSize: 12, color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
