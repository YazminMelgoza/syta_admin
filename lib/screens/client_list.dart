import 'package:flutter/material.dart';
import 'package:syta_admin/screens/client_form.dart';
import 'package:syta_admin/screens/client_info.dart';
import 'package:syta_admin/screens/config/menu/menu_items.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:syta_admin/screens/login_screen.dart';

class ClientList extends StatelessWidget {
  const ClientList({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Clientes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        backgroundColor: Theme.of(context).colorScheme.primary,

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
      body: _ListView(),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView();

  @override
  Widget build(BuildContext context) {

    appMenuItems; // Assuming this holds your list of menu items

    return ListView.builder(
      itemCount: appMenuItems.length + 1, // Add 1 for the "Add Client" container
      itemBuilder: (context, index) {
        if (index == appMenuItems.length) {
          // This is the last item, for adding client
          return _AddClientContainer();
        } else {
          final menuItem = appMenuItems[index];
          return _CustomListTile(menuItem: menuItem);
        }
      },
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // bordes redondeados
        color: Colors.white, // color de fondo
        border: Border.all(color: Colors.black), // borde negro
      ),
      child: ListTile(
        leading: Icon(menuItem.icon),
        trailing: Icon( Icons.arrow_forward_ios_rounded ),
        title: Text(menuItem.title),
        subtitle: Text( menuItem.subTitle ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClientInfor()),
          );
        },
      ),
    );
  }
}

class _AddClientContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // bordes redondeados
        color: Colors.white, // color de fondo
        border: Border.all(color: Colors.black), // borde negro
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the text
          children: const [
            Icon(Icons.add, color: Colors.black),
            Text(" Agregar Cliente", style: TextStyle(color: Colors.black)),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClientForm()),
          );
        },
      ),
    );
  }
}
