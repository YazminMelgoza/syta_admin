import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/create_inspection.dart';
import 'package:syta_admin/screens/add_inspection.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:syta_admin/screens/inspection_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/header.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;

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
      appBar: CustomAppBar(titulo: "Bienvenido"),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: const Row(
                  children: [
                    Text(
                      "Revisiones ",
                      style: TextStyle(
                        color: Color(0xFF1A1A77),
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      " Activas ",
                      style: TextStyle(
                        color: Color(0xFFFF6A00),
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: GestureDetector(
                  onTap: () {
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddInspection(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6A00),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8), // Espacio entre ícono y texto
                        Text(
                          "Agregar Revisión",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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

                  return Container(
                    height: 450,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: carousel.CarouselSlider(
                      options: carousel.CarouselOptions(
                        height: 450,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.9,
                      ),
                      items: inspections.asMap().entries.map((entry) {
                        int index = entry.key;
                        QueryDocumentSnapshot doc = entry.value;
                        Map<String, dynamic> inspectionData =
                        doc.data() as Map<String, dynamic>;
                        String inspectionId = doc.id;
                        String carId = inspectionData['carId'];
                        String userId = inspectionData['userId'];
                        String estimatedDate = inspectionData['estimatedDate'];
                        String title = inspectionData['title'];

                        int millisecondsDate = int.parse(estimatedDate);
                        DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(millisecondsDate);
                        String formattedDate =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                        return FutureBuilder(
                          future: Future.wait([
                            _firebaseFirestore.collection('cars').doc(carId).get(),
                            _firebaseFirestore.collection('users').doc(userId).get(),
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            String carName = snapshot.data![0].get('name');
                            String userName = snapshot.data![1].get('name');

                            return InspectionCard(
                              inspectionId: inspectionId,
                              title: title,
                              userName: userName,
                              carName: carName,
                              formattedDate: formattedDate,
                              totalInspections: inspections.length.toString(),
                              actualInspection: (index + 1).toString(),
                              onTap: () {
                                if (!context.mounted) return;
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
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/scrollArrow.png',
                      height: 30,
                      fit: BoxFit.contain,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Text(
                  "Puedes presionar sobre alguna de las revisiones para conocer más detalles.",
                  textAlign: TextAlign.center,
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}

class InspectionCard extends StatelessWidget {
  final String inspectionId;
  final String title;
  final String userName;
  final String carName;
  final String formattedDate;
  final String totalInspections;
  final String actualInspection;
  final VoidCallback onTap;

  const InspectionCard({
    Key? key,
    required this.inspectionId,
    required this.title,
    required this.userName,
    required this.carName,
    required this.formattedDate,
    required this.totalInspections,
    required this.actualInspection,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(15),
        height: 400, // Altura fija
        decoration: BoxDecoration(
          color: Color(0xFFFFFCF6),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF333333).withOpacity(0.25),
              width: 2,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.person, "Usuario: $userName"),
                    const SizedBox(height: 5),
                    _buildInfoRow(Icons.directions_car, "Vehículo: $carName"),
                    const SizedBox(height: 5),
                    _buildInfoRow(Icons.calendar_today, "Fecha Estimada: $formattedDate"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/herramientas.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Text(
              actualInspection + "/" + totalInspections,
              style: TextStyle(
                color: Color(0xFFFF6A00),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              height: 10,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6A00),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),

    );
  }

  // Widget para las filas de información con iconos pequeños
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Color(0xFF121230),  // Color del ícono pequeño
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
