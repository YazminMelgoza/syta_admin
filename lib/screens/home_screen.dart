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

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Placeholder(),
    ClientList(),
    Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(ap.administratorModel.name),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.timelapse_outlined),
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person_3),
              onPressed: () {
                _onItemTapped(1);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientList()),
                );
              },
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.search_rounded ),
              onPressed: () {
                _onItemTapped(2);
              },
            ),
            label: 'Settings',
          ),
          
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
