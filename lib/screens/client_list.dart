import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/client_form.dart';
import 'package:syta_admin/screens/client_info.dart';
import 'package:syta_admin/screens/config/menu/menu_items.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:syta_admin/screens/login_screen.dart';

class ClientList extends StatelessWidget {
  const ClientList({Key? key}); // Fix the key parameter
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Clientes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
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
      body: FutureBuilder<List<MenuItem>>(
        future: _fetchClientData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<MenuItem> clientList = snapshot.data!;

          return _ListView(clientList: clientList); // Pass clientList to _ListView
        },
      ),
    );
  }

  Future<List<MenuItem>> _fetchClientData() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => _menuItemFromDoc(doc)).toList();
  }

  // Function to create a MenuItem from a DocumentSnapshot
  MenuItem _menuItemFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      title: data['name'] ?? 'No Name', // Handle missing data gracefully
      subTitle: data['email'] ?? 'No Email',
      clientId: data['uid'] ?? '616kTidVW5dfOE1CTBAV0c18V5l1',
      link: '/buttons', // Assuming you have a ClientInfo screen
      icon: Icons.person,
    );
  }
}

class _ListView extends StatelessWidget {
  final List<MenuItem> clientList;

  const _ListView({required this.clientList}); // Add clientList parameter

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clientList.length + 1, // Add 1 for "Add Client" container
      itemBuilder: (context, index) {
        if (index == clientList.length) {
          // This is the last item, for adding client (unchanged)
          return _AddClientContainer();
        } else {
          final menuItem = clientList[index];
          return _CustomListTile(menuItem: menuItem);
        }
      },
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final MenuItem menuItem;

  const _CustomListTile({
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: ListTile(
        leading: Icon(menuItem.icon),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        title: Text(menuItem.title),
        subtitle: Text(menuItem.subTitle),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientInfo(
                clientId: menuItem.clientId, // Pass client ID
                name: menuItem.title,
                email: menuItem.subTitle,
                phone: '', // Add phone number here if available
              ),
            ),
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
