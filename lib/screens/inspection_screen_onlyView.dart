import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../widgets/header.dart';
import 'inspection_detail_screen.dart';

class InspectionScreenOnlyView extends StatefulWidget {
  final String inspectionId;
  const InspectionScreenOnlyView({super.key,required this.inspectionId});

  @override
  State<InspectionScreenOnlyView> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreenOnlyView> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isChecked = false;
  bool isLoading = true;
  late DocumentSnapshot inspectionData;
  void actualizarEstatus( String id, String status, String dateF)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "endDate": dateF});
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

    return isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
      appBar:  CustomAppBar(titulo: "Detalles" ),
      body: Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
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

        ],
      )),
    );
  }
}

