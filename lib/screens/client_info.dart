import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/add_car_form.dart';
import 'package:syta_admin/screens/check_complete_inspections.dart';

import 'check_complete_inspections.dart';

class ClientInfo extends StatelessWidget {
  final String clientId;
  final String name;
  final String email;
  final String phone;

  const ClientInfo({
    required this.clientId,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Usuario",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(name, style: TextStyle(fontSize: 18.0)),
            const SizedBox(height: 20.0),
            Text(
              'Correo:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(email, style: TextStyle(fontSize: 18.0)),
            const SizedBox(height: 20.0),
            Text(
              'Teléfono:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(phone, style: TextStyle(fontSize: 18.0)),
            const SizedBox(height: 40.0),
            const Text(
              'Vehículos Personales:',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cars')
                  .where('actualUserId', isEqualTo: clientId)
                  .snapshots(),
              builder: (context, carSnapshot) {
                if (carSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (carSnapshot.hasError) {
                  return Center(child: Text('Error: ${carSnapshot.error}'));
                }

                final carsData = carSnapshot.data?.docs ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: carsData.map((carDoc) {
                    final carData = carDoc.data() as Map<String, dynamic>;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Auto:',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckCompletedInspections(
                                      carName: carData['name'],
                                      userId: clientId,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                carData['name'] ?? '',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'Placas:',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(carData['plates'] ?? '', style: TextStyle(fontSize: 18.0)),
                        const SizedBox(height: 10.0),
                        Text(
                          'Año:',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(carData['model'] ?? '', style: TextStyle(fontSize: 18.0)),
                        const SizedBox(height: 20.0),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarForm(clientId: clientId)),
                  );
                },
                child: const Text('Agregar Auto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
