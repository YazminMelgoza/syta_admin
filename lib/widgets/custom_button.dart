import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  const CustomButton({ super.key, required this.text, required this.onPressed, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed, 
      style: ButtonStyle(
        backgroundColor: isDisabled ? 
          MaterialStateProperty.all<Color>(Colors.grey) 
          : MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0)
          )
        )
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        )
      )
      );
  }
}