import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
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
  } catch (error) {
    // Handle errors
    print('Error adding data: $error');
  }

}
class _ClientFormState extends State<ClientForm> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String _name = ""; // Stores client name
  String _email = ""; // Stores client email
  String _phone = ""; // Stores client phone number
  String _carMake = ""; // Stores car make
  String _carModel = ""; // Stores car model
  String _carYear = ""; // Stores car year
  Country selectedCountry = Country(
    phoneCode: "52",
    countryCode: "MX",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name:  "Mexico",
    example: "Mexico",
    displayName: "Mexico",
    displayNameNoCountryCode: "Mexico",
    e164Key: "",
  );

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
                      controller: phoneController,
                      onChanged:(value) => setState(() {phoneController.text = value;}),
                      cursorColor: Theme.of(context).primaryColor,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, 
                      ],
                      decoration: InputDecoration(
                        hintText: 'Número de teléfono',
                        prefixIcon: Container(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                      context: context,
                                      countryListTheme: CountryListThemeData(
                                          flagSize: 30.0,
                                          bottomSheetHeight: 450.0,
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        setState(() {
                                          selectedCountry = country;
                                        });
                                      }
                                  );
                                },
                                child: Text(
                                    '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            )
                        ),
                        suffixIcon: phoneController.text.length > 9 ?
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

                    SizedBox(height: 20.0),
                    Padding(padding: EdgeInsets.only(left:180),child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save(); // Save form data

                          String phoneNumber = phoneController.text.trim();
                          _phone = "+${selectedCountry.phoneCode}$phoneNumber";
                          addNewClientAndCar(_name, _email, _phone,);
                          // You can update the database or perform other actions
                          print("Cliente actualizado: $_name, $_email, $_phone");
                          // You can show a success message or navigate elsewhere
                          Navigator.pop(context);
                        }
                        /*if (widget.fromAddInspectionCar) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckInspections(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }*/
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