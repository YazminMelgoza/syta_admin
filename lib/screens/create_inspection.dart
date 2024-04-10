import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:provider/provider.dart';

class CreateInspection extends StatefulWidget {
  const CreateInspection({super.key});

  @override
  State<CreateInspection> createState() => _CreateInspectionState();
}

class _CreateInspectionState extends State<CreateInspection> {
  final formKey = GlobalKey<FormState>();

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nombre del cliente",
                        
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^[a-z A-z]+$').hasMatch(value!)) {
                          return "Registre un nombre correcto";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Número de teléfono",
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1-4}[){0,1}[-\s\./0-9]+$').hasMatch(value!)) {
                          return "Registre un número correcto";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Modelo del vehículo",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: "Detalles de la revisión",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
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