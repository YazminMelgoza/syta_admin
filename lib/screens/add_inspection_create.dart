import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_admin/screens/add_inspection_choose_car.dart';
import 'package:syta_admin/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:syta_admin/provider/auth_provider.dart';

class CreateInspection extends StatefulWidget {
  final String carId;
  final String userId;
  const CreateInspection({super.key, required this.carId, required this.userId});

  @override
  State<CreateInspection> createState() => _CreateInspectionState();
}

class _CreateInspectionState extends State<CreateInspection> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //Input Variables
  final TextEditingController description = TextEditingController();
  final TextEditingController estimatedDate = TextEditingController();
  final TextEditingController title = TextEditingController();

  //Automatic Variables
  final String endDate = "";
  final String startDate = "";
  final String locationId = "";
  final String status = "EN PROGRESO";
  //Functions
  Future<void> _selectDate() async
  {
    DateTime? _picked = await showDatePicker
      (
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
      );
    if(_picked != null)
    {
      estimatedDate.text = _picked.toString().split(" ")[0];

    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Agregar Revisión", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
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
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("Paso 3. Rellena el Formulario:", textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24, // Tamaño de la letra en puntos
                        fontWeight: FontWeight.bold, // Texto en negrita
                      )
                  ),
                ),
                Icon(
                  Icons.car_repair,
                  size: 70, // Tamaño del icono
                  color: Colors.black, // Color del icono (opcional)
                ),
              ],
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: title,
              onChanged:(value) => setState(() {title.text = value;}),
              cursorColor: Theme.of(context).primaryColor,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Titulo',
                suffixIcon: title.text.length > 9 ?
                Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green
                    ),
                    child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 20.0
                    )
                ) : null,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              maxLines: 4,
              controller: description,
              onChanged:(value) => setState(() {description.text = value;}),
              cursorColor: Theme.of(context).primaryColor,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Descripción',
                suffixIcon: description.text.length > 9 ?
                Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green
                    ),
                    child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 20.0
                    )
                ) : null,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: estimatedDate,
              //onChanged:(value) => setState(() {estimatedDate.text = value;}),
              cursorColor: Theme.of(context).primaryColor,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Fecha estimada',
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: estimatedDate.text.length > 9 ?
                Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green
                    ),
                    child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 20.0
                    )
                ) : null,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: true,
              onTap: (){
                _selectDate();
              },
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: ()
                    {
                      String fechaString = estimatedDate.text;
                      String descripcion = description.text; // Obtener el texto de la descripción
                      String titulo = title.text; // Obtener el texto del título

                      // Validación para verificar si la fecha es válida antes de parsear
                      DateTime? fecha;
                      try {
                        fecha = DateTime.parse(fechaString);
                      } catch (e) {
                        fecha = null;
                      }

                      if (fecha == null || fechaString.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('La fecha no es válida o está vacía'),
                          ),
                        );
                        return; // Cancelar el resto de la ejecución
                      }

                      String fechamilisegundos = fecha.millisecondsSinceEpoch.toString();
                      String tiempoActual = DateTime.now().millisecondsSinceEpoch.toString();

                      if (fechamilisegundos.trim().isEmpty || tiempoActual.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Los milisegundos de la fecha o el tiempo actual están vacíos'),
                          ),
                        );
                        return; // Cancelar el resto de la ejecución
                      }

                      if (descripcion.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('La descripción no puede estar vacía'),
                          ),
                        );
                        return; // Cancelar el resto de la ejecución
                      }

                      if (titulo.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('El título no puede estar vacío'),
                          ),
                        );
                        return; // Cancelar el resto de la ejecución
                      }


                      final data = {
                        "carId": widget.carId,
                        "description": descripcion,
                        "endDate": "",
                        "estimatedDate": fechamilisegundos,
                        "locationId": ap.administratorModel.locationId,
                        "startDate": tiempoActual,
                        "status": "EN PROGRESO",
                        "title": titulo,
                        "userId": widget.userId
                      };

                      _firebaseFirestore.collection("inspections").add(data)
                          .then((documentReference) {
                        print("Se añadió correctamente. ID del documento: ${documentReference.id}");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ), (route) => false);

                      })
                          .catchError((error) {
                        print("Ocurrió un error al añadir el documento: $error");
                      });

                      /*
                      String phoneNumber = phoneController.text.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddInspectionCar(
                            numero: "+${selectedCountry.phoneCode}$phoneNumber",
                          ),
                        ),
                      );*/
                    },
                    child:
                    Text("Agregar Revisión")
                )
            ),
          ],
        ),
      ),
    );
  }

}