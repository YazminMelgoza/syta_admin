import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_admin/screens/check_inspections.dart';

import 'package:syta_admin/screens/main_screen.dart';
class InspectionAddDetailScreen extends StatefulWidget {
  final String inspectionId;


  InspectionAddDetailScreen({
        super.key,
        required this.inspectionId,
      });

  @override
  State<InspectionAddDetailScreen> createState() => _InspectionAddDetailScreenState();
}

class _InspectionAddDetailScreenState extends State<InspectionAddDetailScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isChecked = false;
  final TextEditingController _controller = TextEditingController();


  void addDetail(id,description,status,dateF,dateI)
  {
    final detail = <String, String>{
      "description": description,
      "endDate": dateF,
      "inspectionId": id,
      "startDate": dateI,
      "status": status
    };
    _firebaseFirestore.collection("inspectionDetails").add(detail).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Agregar Actualización", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
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
      body: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("AgregarA Actualización",textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  maxLines: 2, // Esto permite que el campo de texto sea multilinea
                  keyboardType: TextInputType.multiline, // Esto también permite que el campo de texto sea multilinea
                  decoration: const InputDecoration(
                    labelText: 'Descripción', // Etiqueta del campo de texto
                    border: OutlineInputBorder(), // Bordes del campo de texto
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const Text("Finalizado: "),
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                        },
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: (){
                    String inputText = _controller.text;

                    if (inputText.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('La descripción no puede estar vacía'),
                        ),
                      );
                      return; // Cancelar el resto de la ejecución
                    }
                    String status = "";
                    String dateF = "";
                    String dateI = "";
                    DateTime now = DateTime.now();
                    dateI = now.millisecondsSinceEpoch.toString();
                    if(_isChecked==true)
                    {
                      status="FINALIZADO";
                      dateF = now.millisecondsSinceEpoch.toString();
                    }else
                    {
                      status="EN PROGRESO";
                    }
                    addDetail(widget.inspectionId,inputText,status,dateF,dateI);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC4C00),
                  ),
                    child: const Text("Agregar Actualización",style: TextStyle(color: Colors.white), ),
                )
              ],
            ),
          )
      ),
    );
  }
}

