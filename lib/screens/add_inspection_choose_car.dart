import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_admin/model/administrator_model.dart';
import 'package:syta_admin/screens/client_form.dart';
import 'package:syta_admin/screens/main_screen.dart';
import 'package:syta_admin/screens/add_inspection_create.dart';



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
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Agregar Revisión ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
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
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(height: 20,),
            FutureBuilder<void>(
              future: Future.wait([getUserId(widget.numero)]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError)
                {
                  return Text('Error: ${snapshot.error}');
                }
                return (userId != "") ?  StreamBuilder<QuerySnapshot>(
                  stream: _firebaseFirestore.collection('cars').where("actualUserId", isEqualTo: userId).snapshots(),
                  builder: (context, snapshot)
                  {
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
                      child: ListView.builder(
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> carData = cars[index].data() as Map<String, dynamic>;
                          String carId = cars[index].id;
                          String model = carData['model'];
                          String name = carData['name'];
                          String plates = carData['plates'];

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  "Paso 2. Selecciona el carro",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.car_repair_outlined),
                                        iconSize: 32,
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CreateInspection(
                                                carId: carId,
                                                userId: userId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Modelo: " + model,
                                                style: TextStyle(fontSize: 12),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                "Placas: " + plates,
                                                style: TextStyle(fontSize: 12),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ) :
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("El usuario no existe",
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                          )
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientForm(fromAddInspectionCar: true),
                            ),
                          );
                        },
                        child: Text("Crear cuenta a Usuario")
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