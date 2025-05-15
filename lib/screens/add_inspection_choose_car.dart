import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_admin/model/administrator_model.dart';
import 'package:syta_admin/screens/client_form.dart';
import 'package:syta_admin/screens/main_screen.dart';
import 'package:syta_admin/screens/add_inspection_create.dart';
import 'package:syta_admin/widgets/custom_action_btn.dart';
import 'package:syta_admin/widgets/header.dart';

import 'add_car_form.dart';



class AddInspectionCar extends StatefulWidget {
  final String numero;
   AddInspectionCar({super.key, required this.numero});

  @override
  State<AddInspectionCar> createState() => _AddInspectionCarState();
}

class _AddInspectionCarState extends State<AddInspectionCar> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String userId = "";

  Future<void> getUserId(userPhone) async
  {
    try {
      await _firebaseFirestore.collection("users").where("phoneNumber", isEqualTo: userPhone).get().then(
            (querySnapshot)
        {
          print("Successfully completed");
            for (var docSnapshot in querySnapshot.docs)
            {
                print('${docSnapshot.id} => ${docSnapshot.data()}');

                userId = docSnapshot.id;
            }
        },
        onError: (e) => print("Error completing: $e"),
      );

    } catch (e) {
      print("Error obteniendo el documento: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Agregar Revisión"),
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(height: 20,),
            Text(
              "Numero del cliente:" + widget.numero,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Paso 2. Selecciona el auto",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore.collection("users").where("phoneNumber", isEqualTo: widget.numero).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Muestra un indicador de carga mientras se espera la respuesta de la base de datos
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var firstDocument = snapshot.data!.docs.first;
                  userId = firstDocument.id;

                } else {
                  userId = "";
                }
                return (userId != "") ?  StreamBuilder<QuerySnapshot>(

                  stream: _firebaseFirestore.collection('cars').where("actualUserId", isEqualTo: userId).snapshots(),
                  builder: (context, snapshot)
                  {
                    print(userId);
                    if (snapshot.connectionState == ConnectionState.waiting)
                    {
                      print(userId);
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

                    List<QueryDocumentSnapshot> cars = snapshot.data!.docs;
                    return Expanded(
                      child: Column(
                        children: [
                          (cars.isNotEmpty) ? Expanded(
                            child:  ListView.builder(
                              itemCount: cars.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> carData = cars[index].data() as Map<String, dynamic>;
                                String carId = cars[index].id;
                                String model = carData['model'];
                                String name = carData['name'];
                                String plates = carData['plates'];

                                return  CarItem(carData: carData, uid: userId, carId: carId);

                              },
                            ),
                          ): Container(
                            child: Column(
                              children: [
                                Text(
                                  "Numero del cliente:" + widget.numero,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                "El Usuario no cuenta con ningún auto actualmente...",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),),
                          SizedBox(height: 20,),

                          CustomActionButton(
                              text: "Agregar Auto",
                              icon: Icons.add,
                              backgroundColor: Color(0xFFFF6A00),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CarForm(clientId: userId)),
                                );
                              },
                          ),

                        ],
                      ),
                    );
                  },
                ) :
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      Text("Ups, Parece que el usuario no tiene una cuenta, revisa el numero de telefono e intentalo de nuevo o crea una nueva cuenta al usuario",
                          style: TextStyle(
                            fontSize: 20,

                          )
                      ),
                      SizedBox(height: 20,),
                      CustomActionButton(
                          text: "Crear cuenta al Usuario",
                          icon: Icons.add,
                          backgroundColor: Color(0xFFFF6A00),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientForm(fromAddInspectionCar: true),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

class CarItem extends StatelessWidget {
  final Map<String, dynamic> carData;
  final String uid;
  final String carId;

  const CarItem({Key? key, required this.carData, required this.uid, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateInspection(
              carId: carId,
              userId: uid,
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
