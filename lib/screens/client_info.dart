import 'package:flutter/material.dart';

class ClientInfor extends StatelessWidget {
  const ClientInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Usuario", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            width: double.infinity, 
            color: Colors.white,
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text('Luis Mario', style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 20.0),
                  Text('Correo:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text('correo@correo.com', style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 20.0),
                  Text('Teléfono:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text('1234567890', style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 40.0),
                  Text('Vehículos Personales:', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.0),
                  Text('Auto:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text('Toyota', style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 20.0),
                  Text('Modelo:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text('Camry', style: TextStyle(fontSize: 18.0), ),
                  SizedBox(height: 20.0),
                  Text('Año:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), ),
                  Text( '2023', style: TextStyle(fontSize: 18.0),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}