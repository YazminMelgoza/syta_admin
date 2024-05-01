import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_admin/screens/add_inspection_choose_car.dart';
import 'package:country_picker/country_picker.dart';
import 'package:syta_admin/screens/main_screen.dart';

class AddInspection extends StatefulWidget {
  const AddInspection({super.key});

  @override
  State<AddInspection> createState() => _AddInspectionState();
}

class _AddInspectionState extends State<AddInspection> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Paso 1. Ingresa el Numero de usuario:", textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24, // Tamaño de la letra en puntos
                  fontWeight: FontWeight.bold, // Texto en negrita
                )
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: phoneController,
              onChanged:(value) => setState(() {phoneController.text = value;}),
              cursorColor: Theme.of(context).primaryColor,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.phone,
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
            SizedBox(height: 10,),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: ()
                    {
                      String phoneNumber = phoneController.text.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddInspectionCar(
                            numero: "+${selectedCountry.phoneCode}$phoneNumber",
                          ),
                        ),
                      );
                    },
                    child:
                    Text("Buscar")
                )
            ),
          ],
        ),
      ),
    );
  }

}