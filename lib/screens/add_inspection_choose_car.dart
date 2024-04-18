import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_admin/screens/main_screen.dart';


class AddInspectionCar extends StatefulWidget {
  final String numero;
   AddInspectionCar({super.key, required this.numero});

  @override
  State<AddInspectionCar> createState() => _AddInspectionCarState();
}

class _AddInspectionCarState extends State<AddInspectionCar> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;



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
            Text("Numero del cliente:"+widget.numero, textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20, // Tamaño de la letra en puntos
                  fontWeight: FontWeight.bold, // Texto en negrita
                )
            ),
            SizedBox(height: 10,),
            Text("Paso 2. Selecciona el carro", textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24, // Tamaño de la letra en puntos
                  fontWeight: FontWeight.bold, // Texto en negrita
                )
            ),
            SizedBox(height: 20,),
            //Lista de carros
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore.collection('cars').snapshots(),
              builder: (context, snapshot)
              {
                if (snapshot.connectionState == ConnectionState.waiting)
                {
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
                      String documentId = cars[index].id;
                      String model = carData['model'];
                      String name = carData['name'];
                      String plates = carData['plates'];


                      return Center(
                        child: Container(
                          //width: 200,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent, // Color de fondo del Container
                            borderRadius: BorderRadius.circular(10), // Radio de borde del Container
                          ),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {

                                },
                                icon: Icon(Icons.car_repair_outlined),
                                iconSize: 32,
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {

                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(name,
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                        Text("Modelo: "+model, style: TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                        Text("Placas: "+plates, style: TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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