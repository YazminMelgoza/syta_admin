import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormCar extends StatefulWidget {
  const FormCar({Key? key}) : super(key: key);

  @override
  State<FormCar> createState() => _FormCarState();
}
final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<void> addNewCar(String carMake, String year, String carModel) async {
  try{
    DocumentReference userDocRef = await _firebaseFirestore.collection("users").add({
      
    });

    // Capture the user ID (document ID)
    String userId = userDocRef.id;

    // Add car data to 'cars' collection with the captured user ID
    await _firebaseFirestore.collection("cars").add({
      "plates": carMake,
      "name": carModel,
      "model": year,
      "actualUserId": userId, // Include the user ID here
    });
  } catch (error) {
    // Handle errors
    print('Error adding data: $error');
  }

}
class _FormCarState extends State<FormCar> {
  final _formKey = GlobalKey<FormState>(); 
  String _carMake = ""; // Stores car make
  String _carModel = ""; // Stores car model
  String _carYear = ""; // Stores car year

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Agregar Auto",
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
                    SizedBox(height: 20.0),
                    Text(
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
                    ),
                    SizedBox(height: 20.0),
                    Padding(padding: EdgeInsets.only(left:180),child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save(); // Save form data
                          // Handle form submission logic here
                          addNewCar(_carMake, _carModel, _carYear);
                          // You can update the database or perform other actions
                          print("Cliente actualizado: $_carMake, $_carModel, $_carYear");
                          // You can show a success message or navigate elsewhere
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Guardar Auto"),
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


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  State<CarForm> createState() => _CarFormState();
}
final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
Future<void> addNewClientAndCar(String name, String email, String phone, String carMake, String model, String year, String carModel) async {
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
      "plates": carMake,
      "name": carModel,
      "model": year,
      "actualUserId": userId, // Include the user ID here
    });
  } catch (error) {
    // Handle errors
    print('Error adding data: $error');
  }

}
class _CarFormState extends State<CarForm> {
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
          "Agregar Auto",
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
                    SizedBox(height: 20.0),
                    Text(
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
                    ),
                    SizedBox(height: 20.0),
                    Padding(padding: EdgeInsets.only(left:180),child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save(); // Save form data
                          // Handle form submission logic here
                          addNewClientAndCar(_name, _email, _phone, _carMake, _carModel, _carYear, _carModel);
                          // You can update the database or perform other actions
                          print("Cliente actualizado: $_name, $_email, $_phone");
                          // You can show a success message or navigate elsewhere
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Guardar Auto"),
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

 */