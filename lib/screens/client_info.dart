import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/add_car_form.dart';
import 'package:syta_admin/screens/check_complete_inspections.dart';

class ClientInfo extends StatelessWidget {
  final String clientId;
  final String name;
  final String email;
  final String phone;

  final String carMake;
  final String carModel;
  final String year;
  final String userId;

  const ClientInfo({
    required this.clientId,
    required this.name,
    required this.email,
    required this.phone,

    required this.carMake,
    required this.carModel,
    required this.year,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(clientId).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (userSnapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${userSnapshot.error}')));
        }
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Scaffold(body: Center(child: Text('No user data found')));
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('cars').where('actualUserId', isEqualTo: userId).get(),
          builder: (context, carSnapshot) {
            if (carSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (carSnapshot.hasError) {
              return Scaffold(body: Center(child: Text('Error: ${carSnapshot.error}')));
            }

            final List<Map<String, dynamic>> carsData = carSnapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: const Text(
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
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(name, style: const TextStyle(fontSize: 18.0)),
                    const SizedBox(height: 20.0),
                    Text(
                      'Correo:',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(email, style: const TextStyle(fontSize: 18.0)),
                    const SizedBox(height: 20.0),
                    Text(
                      'Teléfono:',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(userData['phoneNumber'], style: const TextStyle(fontSize: 18.0)),
                    const SizedBox(height: 40.0),
                    
                    const Text(
                      'Vehículos Personales:',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    for (var carData in carsData) ...[
                      Row(
                        children: [
                          
                          Text(
                            'Auto:',
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                              carData['name'],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Placas:',
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(carData['plates'], style: const TextStyle(fontSize: 18.0)),
                      const SizedBox(height: 10.0),
                      Text(
                        'Año:',
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(carData['model'], style: const TextStyle(fontSize: 18.0)),
                      const SizedBox(height: 20.0),
                    ],

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CarForm()),
                          );
                        },
                        child: const Text('Agregar Auto'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}