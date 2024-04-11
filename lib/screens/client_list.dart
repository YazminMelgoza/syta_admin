import 'package:flutter/material.dart';
import 'package:syta_admin/screens/client_info.dart';
import 'package:syta_admin/screens/config/menu/menu_items.dart';

class ClientList extends StatelessWidget {
  const ClientList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _ListView(),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView();

  @override
  Widget build(BuildContext context) {

    appMenuItems;


    return ListView.builder(
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];

        return _CustomListTile(menuItem: menuItem);
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