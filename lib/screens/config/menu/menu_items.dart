import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle; 
  final String link;
  final IconData icon;

  const MenuItem ({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon
  });

}


const appMenuItems = <MenuItem>[

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