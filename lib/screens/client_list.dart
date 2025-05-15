import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/client_form.dart';
import 'package:syta_admin/screens/client_info.dart';
import 'package:syta_admin/screens/config/menu/menu_items.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:syta_admin/widgets/custom_action_btn.dart';
import 'package:syta_admin/widgets/header.dart';

class ClientList extends StatelessWidget {
  const ClientList({Key? key}); // Fix the key parameter
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(titulo: "Clientes"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<MenuItem> clientList = snapshot.data!.docs.map((doc) => _menuItemFromDoc(doc)).toList();
          return
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    CustomActionButton(
                        text: "Agregar Cliente",
                        icon: Icons.add,
                        backgroundColor:  const Color(0xFFFF6A00),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ClientForm()),
                          );
                        },
                    ),
                    SizedBox(height: 10,),
                    _ListView(clientList: clientList),

                  ],
                ),
              );
            //_ListView(clientList: clientList);
        },
      ),
    );
  }

  Future<List<MenuItem>> _fetchClientData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    return querySnapshot.docs.map((doc) => _menuItemFromDoc(doc)).toList();
  }

  // Function to create a MenuItem from a DocumentSnapshot
  MenuItem _menuItemFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      title: data['name'] ?? 'No Name', // Handle missing data gracefully
      subTitle: data['email'] ?? 'No Email',
      clientId: doc.id,
      phone: data['phoneNumber'] ?? 'No Phone',
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
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: clientList.length ,
      itemBuilder: (context, index) {
        final menuItem = clientList[index];
        return UserItem(menuItem: menuItem);
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
      margin: const EdgeInsets.all(5.0),
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
                phone: menuItem.phone, // Add phone number here if available
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

class UserItem extends StatelessWidget {
  final MenuItem menuItem;

  const UserItem({
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientInfo(
              clientId: menuItem.clientId, // Pass client ID
              name: menuItem.title,
              email: menuItem.subTitle,
              phone: menuItem.phone, // Add phone number here if available
            ),
          ),
        );

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          menuItem.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text( menuItem.subTitle, style: const TextStyle(fontSize: 18.0)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/usuarioCuadrado.png',
                    height: 40,
                    fit: BoxFit.contain,
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
