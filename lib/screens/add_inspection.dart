import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInspection extends StatefulWidget {
  const AddInspection({super.key});

  @override
  State<AddInspection> createState() => _AddInspectionState();
}

class _AddInspectionState extends State<AddInspection> {
  final TextEditingController _searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar usuario...',
          ),
          onChanged: (value) {

          },
        ),
      ),
      body: Container(),
    );
  }

}