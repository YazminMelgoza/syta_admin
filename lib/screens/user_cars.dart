import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:syta_admin/provider/auth_provider.dart' as firebase_auth_providers;

import '../widgets/header.dart';
import 'completed_inspections.dart';

class CarData extends StatelessWidget {
  final String uid;
  const CarData({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<firebase_auth_providers.AuthProvider>(context, listen: false);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (userSnapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${userSnapshot.error}')));
        }
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('No user data found')));
        }

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('cars')
              .where('actualUserId', isEqualTo: uid)
              .get(),
          builder: (context, carSnapshot) {
            if (carSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (carSnapshot.hasError) {
              return Scaffold(body: Center(child: Text('Error: ${carSnapshot.error}')));
            }
            if (!carSnapshot.hasData || carSnapshot.data!.docs.isEmpty) {
              return Scaffold(
                  appBar: CustomAppBar(titulo: "Vehiculos"),
                  body: Center(child: Text('Este usuario no cuenta con ningún vehículo registrado')));
            }


            final List<Map<String, dynamic>> carsData = carSnapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList();

            return Scaffold(
              appBar: CustomAppBar(titulo: "Vehiculos"),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var carData in carsData) ...[
                      CarItem(carData: carData, uid: uid),
                    ],

                    Row(
                      children: [
                        Expanded( // o Flexible
                          child: Text(
                            "Presiona sobre cualquiera de los vehículos para ver su historial de reparaciones",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    )

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

class CarItem extends StatelessWidget {
  final Map<String, dynamic> carData;
  final String uid;

  const CarItem({Key? key, required this.carData, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompletedInspections(
              carName: carData['name'].toString(),
              userId: uid,
              carIdHistorial: carData['id'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
                        const Text(
                          'Auto: ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),

                        Text(
                          carData['name'],
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Placas: ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(carData['plates'], style: const TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Año: ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(carData['model'], style: const TextStyle(fontSize: 18.0)),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/car.png',
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

