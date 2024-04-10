import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionDetailScreen extends StatefulWidget {
  final String inspectionDetailId;
  final String description;
  final String endDate;
  final String startDate;
  final String status;

  InspectionDetailScreen(
      {
        super.key,
        required this.inspectionDetailId,
        required this.description,
        required this.endDate,
        required this.startDate,
        required this.status,
      });

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isChecked = false;
  TextEditingController _controller = TextEditingController();
  @override
  void initState()
  {
    super.initState();

    addTextToFields();
  }

  void addTextToFields()
  {
    setState(() {
      _controller.text = widget.description;
      if(widget.status=="FINALIZADO")
      {
        _isChecked = true;
      }
    });
  }

  void updateDetail(id,description,status,date)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "description": description,"endDate": date});
  }
  void deleteDoc(id)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).delete().then(
          (doc) => Navigator.pop(context),
      onError: (e) => print("Error updating document $e"),
    );

  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("SYTA  ${ap.locationModel.name}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Center(
          child: Container(
            margin:EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Container(
                  //margin:EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Detallle de Actualización",textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(onPressed: ()
                      {
                        // Muestra el mensaje modal cuando se presiona el botón
                        showDialog(
                          context: context,
                          builder: (BuildContext context)
                          {
                            return AlertDialog(
                              title: Text('Eliminando Registro'),
                              content: Text('¿Está seguro que desea eliminar este registro?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.of(context).pop();
                                    deleteDoc(widget.inspectionDetailId);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                        icon: Icon(Icons.delete),
                        iconSize: 32,
                      ),
                    ],
                  ),
                ),
                /*
                Text("Detalle de Inspección:  " + widget.inspectionDetailId),
                Text("Descripcion: "+ widget.description),
                Text("Inicio: "+ widget.startDate),
                Text("Final: "+ widget.endDate),
                Text("Status: "+ widget.status),*/
                TextField(
                  controller: _controller,
                  maxLines: null, // Esto permite que el campo de texto sea multilinea
                  keyboardType: TextInputType.multiline, // Esto también permite que el campo de texto sea multilinea
                  decoration: InputDecoration(
                    labelText: 'Descripción', // Etiqueta del campo de texto
                    border: OutlineInputBorder(), // Bordes del campo de texto
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Finalizado: "),
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
                    String status = "";
                    String date = "";
                    if(_isChecked==true)
                    {
                      status="FINALIZADO";
                      DateTime now = DateTime.now();
                      date = now.millisecondsSinceEpoch.toString();
                    }else
                    {
                      status="EN PROGRESO";
                    }
                    updateDetail(widget.inspectionDetailId,_controller.text,status,date);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFC4C00),
                  ),
                    child: Text("Guardar Cambios",style: TextStyle(color: Colors.white), ),
                )
              ],
            ),
          )
      ),
    );
  }
}

