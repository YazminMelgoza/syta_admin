import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/create_inspection.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:provider/provider.dart';

class CheckInspections extends StatefulWidget {
  const CheckInspections({super.key});

  @override
  State<CheckInspections> createState() => _CheckInspectionsState();
}

class _CheckInspectionsState extends State<CheckInspections> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(  
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Lista de Revisiones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(  
              onPressed: () {
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateInspection(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              color: Colors.blue, 
            ),
          ],
        ),
        Align(  
            alignment: Alignment.center,  // Center the container horizontally
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue, // You can change the color as desired
                borderRadius: BorderRadius.circular(10), // This makes the border circular
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Versa 2021 07/03/24'),
                  const Icon(Icons.visibility, color: Colors.white), // You can change the icon as desired
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}