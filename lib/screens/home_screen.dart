import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/screens/client_list.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 0;

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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(ap.administratorModel.name),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ClientList()
            )
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon( Icons.timelapse_outlined ),
            activeIcon: Icon( Icons.timelapse ),
            label: 'Revisiones',
            backgroundColor: Colors.blue, 
          ),

          BottomNavigationBarItem(
            icon: Icon( Icons.person_3_outlined ),
            activeIcon: Icon( Icons.person_3 ),
            label: 'Clientes',
            backgroundColor: Colors.red, 
          ),

          BottomNavigationBarItem(
            icon: Icon( Icons.search_outlined ),
            activeIcon: Icon( Icons.search_rounded ),
            label: 'Detalles',
            backgroundColor: Colors.purple, 
          ),

          BottomNavigationBarItem(
            icon: Icon( Icons.blur_linear_outlined ),
            activeIcon: Icon( Icons.blur_linear ),
            label: 'Sucursal',
            backgroundColor: Colors.green, 
          ),
        ],
      ),
    );
  }
}
