import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/check_inspections.dart';
import 'package:syta_admin/screens/home_screen.dart';
import 'package:syta_admin/screens/inspection_detail_screen.dart';
import 'package:syta_admin/screens/inspection_Adddetail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syta_admin/screens/main_screen.dart';
import 'package:syta_admin/widgets/header.dart';

import '../widgets/custom_action_btn.dart';

class InspectionScreen extends StatefulWidget {
  final String inspectionId;
  final String carName;
  const InspectionScreen({super.key,required this.inspectionId, required this.carName});


  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isChecked = false;
  bool isLoading = true;
  late DocumentSnapshot inspectionData;
  void actualizarEstatus( String id, String status, String dateF)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "endDate": dateF});
  }


  void finalizarInspeccion(BuildContext context, String id, String statusIns)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar finalización"),
          content: const Text("¿Estás seguro de que quieres finalizar esta revisión?, El cliente sabrá que ya puede pasar por su automovil"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Actualiza la inspección y cierra la pantalla
                String currentTimeInMillis = DateTime.now().millisecondsSinceEpoch.toString();
                _firebaseFirestore.collection("inspections").doc(id).update(
                    {
                      "status": statusIns,
                      "endDate": currentTimeInMillis
                    }
                );
                Navigator.pop(context); // Cierra la pantalla actual
                Navigator.pop(context); // Cierra la ventana modal
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchInspectionData();
  }

  Future<void> fetchInspectionData() async {
    try {
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection('inspections')
          .doc(widget.inspectionId)
          .get();
      if (documentSnapshot.exists) {
        setState(() {
          inspectionData = documentSnapshot;

          isLoading = false;

        });
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Documento no encontrado');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error al cargar los datos');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
      appBar: CustomAppBar(titulo: "Detalles"),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${inspectionData['title']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        inspectionData['status'],
                      )

                    ],
                  ),
                ),
                Image.asset(
                  'assets/img/herramientas.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 1,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6A00),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          SizedBox(height: 10,),
          CustomActionButton(
            text: "Agregar Actualización",
            icon: Icons.add,
            backgroundColor: const Color(0xFFFF6A00),
            onTap: () {
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspectionAddDetailScreen(
                    inspectionId: widget.inspectionId,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.collection('inspectionDetails').where("inspectionId", isEqualTo: widget.inspectionId).snapshots(),
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
              List<QueryDocumentSnapshot> users = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
                    String documentId = users[index].id;
                    String userStatus = userData['status'];
                    String endDate = "";
                    int milliseconsDate = int.parse(userData['startDate']);
                    DateTime startNormalDate = DateTime.fromMillisecondsSinceEpoch(milliseconsDate);
                    String startDate = startNormalDate.toString();
                    //Date in millisecons
                    if(userData['status']=="FINALIZADO"){
                      int fechaEnMilisegundos = int.parse(userData['endDate']); // Por ejemplo, 1617948600000 representa el 09 de abril de 2021
                      DateTime fechaNormal = DateTime.fromMillisecondsSinceEpoch(fechaEnMilisegundos);
                      endDate = fechaNormal.toString();
                    }


                    return Center(
                      child: Container(
                        //width: 200,
                        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(0),
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFF333333).withOpacity(0.25),
                              width: 0,
                            ),
                          ),
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    if (!context.mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InspectionDetailScreen(
                                            inspectionDetailId: documentId,
                                            description: userData['description'],
                                            endDate: endDate,
                                            startDate: startDate,
                                            status: userData['status']
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(userData['description'],
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(endDate,
                                          style: TextStyle(fontSize: 12),textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                                String dateF = "";
                                String status = "";
                                if (userData['status']=="EN PROGRESO")
                                {
                                  status = "FINALIZADO";
                                  DateTime now = DateTime.now();
                                  dateF = now.millisecondsSinceEpoch.toString();
                                }else
                                {
                                  status = "EN PROGRESO";
                                }
                                actualizarEstatus(documentId,status, dateF);
                              },
                              icon: (userStatus=="FINALIZADO") ? Icon(
                                Icons.check_circle,
                                color: Color(0xFFFF731D), // Color hexadecimal #FF731D
                              ) : Icon(Icons.check_circle_outline),
                              iconSize: 40,
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

          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (!context.mounted) return;
              finalizarInspeccion(context,widget.inspectionId, "FINALIZADO");
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 8, 99),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.done_all, color: Colors.white),
                  SizedBox(width: 8), // Espacio entre ícono y texto
                  Text(
                    "Finalizar Revisión",
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

