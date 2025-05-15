import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syta_admin/screens/inspection_screen.dart';

import '../widgets/header.dart';
import 'inspection_screen_onlyView.dart';

class CompletedInspections extends StatelessWidget {
  final String carName;
  final String userId;
  final String carIdHistorial;

  const CompletedInspections({
    required this.carName,
    required this.userId,
    required this.carIdHistorial,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Historial"),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('cars')
            .where('actualUserId', isEqualTo: userId)
            .where('name', isEqualTo: carName)
            .get(),
        builder: (context, carSnapshot) {
          if (carSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (carSnapshot.hasError) {
            return Center(child: Text('Error: ${carSnapshot.error}'));
          }
          if (!carSnapshot.hasData || carSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No se encontró el auto: $carName'));
          }

          final carData = carSnapshot.data!.docs.first.data() as Map<String, dynamic>;
          final carId = carData['id'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('inspections')
                .where('carId', isEqualTo: carIdHistorial)
                .where('status', isEqualTo: 'FINALIZADO')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay revisiones finalizadas para $carName'));
              }
              List<QueryDocumentSnapshot> inspections = snapshot.data!.docs;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: inspections.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> inspectionData = inspections[index].data() as Map<String, dynamic>;
                        String description = inspectionData['description'];
                        String title = inspectionData['title'];
                        String documentId = inspections[index].id;
                        String endDate = inspectionData['endDate'];
                        String startDate = inspectionData['startDate'];
                        String status = inspectionData['status'];
                        String carId = inspectionData['carId'];

                        int millisecondsDate = int.parse(endDate);
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsDate);
                        String endFormattedDate =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                        return InspectionItem(
                          inspectionData: inspectionData,
                          id: documentId,
                          endFormattedDate: endFormattedDate,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InspectionItem extends StatelessWidget {
  final Map<String, dynamic> inspectionData;
  final String id;
  final String endFormattedDate;

  const InspectionItem({Key? key,
    required this.inspectionData,
    required this.id,
    required this.endFormattedDate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  InspectionScreenOnlyView(
              inspectionId: id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, top: 0, left: 10, right: 10),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            inspectionData['title'] ,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    _buildInfoRow(Icons.calendar_month,endFormattedDate),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            inspectionData['description'] ,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/herramientas.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ],
  );
}
