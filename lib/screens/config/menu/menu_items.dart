import 'package:flutter/material.dart';

class MenuItem {
  final String clientId;
  final String title;
  final String subTitle; 
  final String link;
  final IconData icon;
  final String phone;

  const MenuItem ({
    required this.clientId,
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
    required this.phone,
  });



}


/* const appMenuItems = <MenuItem>[

  MenuItem(
    title: 'Jesus Garza Mora', 
    subTitle: 'correo@correo.com', 
    link: '/buttons', 
    icon: Icons.person
  ),

  MenuItem(
    title: 'Luis Mario ', 
    subTitle: 'correo@correo.com', 
    link: '/card', 
    icon: Icons.person
  ),

  MenuItem(
    title: 'Jesus Garza Mora', 
    subTitle: 'correo@correo.com', 
    link: '/buttons', 
    icon: Icons.person
  ),

  MenuItem(
    title: 'Luis Mario ', 
    subTitle: 'correo@correo.com', 
    link: '/card', 
    icon: Icons.person
  ),



];

*/