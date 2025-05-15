import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const CustomAppBar({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFFFCF6),
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(
          color: Color(0xFFE0E0E0), // Color gris
          width: 1, // Grosor del borde
        ),
      ),
      leading: Navigator.canPop(context)
          ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF1A1A77),
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context); // Acción de retroceder
            },
      ): null,
      title: Stack(
        children: [
          //Sombra
          Positioned(
            top: 2,
            child: Text(
              titulo,
              style: TextStyle(
                color: Colors.black.withOpacity(0.3), // Color de la sombra
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Texto original
          Text(
            titulo,
            style: TextStyle(
              color: Color(0xFF1A1A77),
              fontWeight: FontWeight.w600,
                fontSize: 28,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Stack(
            children: [
              // Sombra
              Positioned(
                top: 2, // Desplazamiento de la sombra
                child: Image.asset(
                  'assets/logo.png',
                  height: 40,
                  color: Colors.black.withOpacity(0.3), // Sombra en negro con opacidad
                ),
              ),
              // Imagen original
              Image.asset(
                'assets/logo.png',
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
