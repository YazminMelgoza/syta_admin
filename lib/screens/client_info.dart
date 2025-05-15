import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/add_car_form.dart';
import 'package:syta_admin/screens/check_complete_inspections.dart';
import 'package:syta_admin/screens/user_cars.dart';
import 'package:syta_admin/widgets/custom_action_btn.dart';
import 'package:syta_admin/widgets/header.dart';

import 'check_complete_inspections.dart';

class ClientInfo extends StatelessWidget {
  final String clientId;
  final String name;
  final String email;
  final String phone;

  const ClientInfo({
    required this.clientId,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Cliente"),
      body: Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      padding: const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFCF6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF333333).withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [

                          Image.asset(
                            'assets/img/usuarioCuadrado.png',
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width:24),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: (name != "") ?
                                  Text(
                                      name,
                                      style: TextStyle(
                                        color: Color(0xFF121230),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ) :
                                  Text("No Definido",
                                      style: TextStyle(
                                        color: Color(0xFF121230),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                size: 13, // Tamaño del icono
                                color: Color(0xFF121230), // Color del icono
                              ),
                              (name != "") ?
                              Text("Correo: " + email,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                ),
                              ) :
                              Text("No Definido",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 13, // Tamaño del icono
                                color: Color(0xFF121230), // Color del icono
                              ),
                              Text("Telefono: " + phone,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20,),
                          CustomActionButton(
                              text: "Ver Autos",
                              icon: Icons.directions_car,
                              backgroundColor: Color(0xFF1A1A77),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CarData(uid: clientId),
                                  ),
                                );
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],

          )
      ),
    );
  }
}