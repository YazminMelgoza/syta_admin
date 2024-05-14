import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/check_inspections.dart';

class ClientForm extends StatefulWidget {
  final bool fromAddInspectionCar;
  const ClientForm({Key? key, this.fromAddInspectionCar = false}) : super(key: key);

  @override
  State<ClientForm> createState() => _ClientFormState();
}
final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
Future<void> addNewClientAndCar(String name, String email, String phone) async {
  try{
    DocumentReference userDocRef = await _firebaseFirestore.collection("users").add({
      "name": name,
      "email": email,
      "phoneNumber": phone,
    });

    // Capture the user ID (document ID)
    String userId = userDocRef.id;

    // Add car data to 'cars' collection with the captured user ID
    await _firebaseFirestore.collection("cars").add({
    });
  } catch (error) {
    // Handle errors
    print('Error adding data: $error');
  }

}
class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String _name = ""; // Stores client name
  String _email = ""; // Stores client email
  String _phone = ""; // Stores client phone number
  String _carMake = ""; // Stores car make
  String _carModel = ""; // Stores car model
  String _carYear = ""; // Stores car year

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Agregar Cliente",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informacion del cliente',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      initialValue: _name, // Set initial value
                      decoration: const InputDecoration(
                        labelText: "Nombre:",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese un nombre.";
                        }
                        return null;
                      },
                      onSaved: (newValue) => _name = newValue ?? "", // Save new value
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _email,
                      decoration: const InputDecoration(
                        labelText: "Correo:",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese un correo electrónico.";
                        }
                        return null;
                      },
                      onSaved: (newValue) => _email = newValue ?? "",
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _phone,
                      decoration: const InputDecoration(
                        labelText: "Teléfono:",
                      ),
                      keyboardType: TextInputType.phone, // Set keyboard type
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese un número de teléfono.";
                        }
                        return null;
                      },
                      onSaved: (newValue) => _phone = newValue ?? "",
                    ),
                    SizedBox(height: 40.0),
                    /*Text(
                      'Vehículos Personales:',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _carMake,
                      decoration: const InputDecoration(
                        labelText: "Placas:",
                      ),
                      onSaved: (newValue) => _carMake = newValue ?? "",
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _carModel,
                      decoration: const InputDecoration(
                        labelText: "Modelo:",
                      ),
                      onSaved: (newValue) => _carModel = newValue ?? "",
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _carYear,
                      decoration: const InputDecoration(
                        labelText: "Año:",
                      ),
                      keyboardType: TextInputType.number, // Set keyboard type
                      onSaved: (newValue) => _carYear = newValue ?? "",
                    ),*/
                    SizedBox(height: 20.0),
                    Padding(padding: EdgeInsets.only(left:180),child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save(); // Save form data
                          // Handle form submission logic here
                          addNewClientAndCar(_name, _email, _phone,);
                          // You can update the database or perform other actions
                          print("Cliente actualizado: $_name, $_email, $_phone");
                          // You can show a success message or navigate elsewhere
                        }
                        if (widget.fromAddInspectionCar) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckInspections(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Guardar Cliente"),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
