import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/check_inspections.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateInspection extends StatefulWidget {
  const CreateInspection({super.key});

  @override
  State<CreateInspection> createState() => _CreateInspectionState();
}

class _CreateInspectionState extends State<CreateInspection> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _placasController = TextEditingController();
  TextEditingController _date = TextEditingController();
  List<String> items = [ 'Versa 2021', 'Vento 2020'];
  String? selectedItem = 'Versa 2021';

  @override
  void initState() {
    super.initState();
    _date.text = DateFormat('dd/MM/yyyy').format(DateTime(2024, 3, 7));
  }

  void _showCarFormDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del vehículo'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _marcaController,
                    decoration: InputDecoration(labelText: 'Marca'),
                  ),
                  TextFormField(
                    controller: _modeloController,
                    decoration: InputDecoration(labelText: 'Modelo'),
                  ),
                  TextFormField(
                    controller: _placasController,
                    decoration: InputDecoration(labelText: 'Placas'),
                  ),
                  // Otros campos del formulario del vehículo
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Agregar el modelo ingresado a la lista de items
                  items.add(_modeloController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
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
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Nueva Inspección',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: TextEditingController(text: "Falla neumatico"),
                      decoration: InputDecoration(
                        labelText: "Ingrese el problema",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^[a-z A-z]+$').hasMatch(value!)) {
                          return "Registre un titulo correcto";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                    controller: TextEditingController(text: "Falla de neumatico en la parte trasera"),
                      minLines: 1,
                      maxLines: 20,
                      decoration: InputDecoration(
                        labelText: "Detalles de la revisión",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: TextEditingController(text: "Juancho"),
                      decoration: InputDecoration(
                        labelText: "Ingrese el nombre del cliente",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^[a-z A-z]+$').hasMatch(value!)) {
                          return "Registre el nombre correcto";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20), child:SizedBox(
                        width: 250.0,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Vehículos del cliente",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          value: selectedItem,
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: const TextStyle(fontSize: 18)),
                          ))
                              .toList(),
                          onChanged: (item) => setState(() => selectedItem = item),
                        ),
                      ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 15), child: Container(
                        width: 60.0, // Ancho y alto iguales para formar un cuadrado
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            _showCarFormDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados para suavizar la apariencia
                            ),
                          ),
                          child: Text(
                            "+",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: _date,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        icon: Icon(Icons.calendar_today_rounded),
                        labelText: "Selecciona una fecha límite"
                      ),
                      onTap: () async{
                        DateTime? pickeddate = await showDatePicker(
                          context: context, 
                          initialDate: DateTime(2024, 3, 7),
                          firstDate: DateTime(2000), 
                          lastDate: DateTime(2201)
                        );
                        if(pickeddate != null){
                          setState(() {
                            _date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckInspections(),
                        ),
                      );
                    },
                    child: const Text("Confirmar"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
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