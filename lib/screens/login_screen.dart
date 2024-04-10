import 'package:flutter/material.dart';
import 'package:syta_admin/provider/auth_provider.dart';
import 'package:syta_admin/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.selection = TextSelection.fromPosition(
      TextPosition(offset: emailController.text.length)
    );
    passwordController.selection = TextSelection.fromPosition(
      TextPosition(offset: passwordController.text.length)
    );
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            // make scrollable content 
            child: SingleChildScrollView(
              child: Column(
              children: [
                Image.asset('assets/logo.png', height: 250),
                const SizedBox(height: 20.0),
                const Text(
                  'Inicia Sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Inicia Sesión con la cuenta de la sucursal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                  ),
                ),

                const SizedBox(height: 20.0),
                textField(controller: emailController, hintText: 'Correo', icon: Icons.email, isObscure: false),
                const SizedBox(height: 20.0),
                // custom button
                textField(controller: passwordController, hintText: 'Contraseña', icon: Icons.lock, isObscure: true),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 500,
                  child: CustomButton(
                    text: 'Iniciar Sesion',
                    onPressed: () => signIn(),
                    isDisabled: emailController.text.isEmpty || passwordController.text.isEmpty,
                  )
                ),
              ]
            )
          )
          )
        ),
      )
    );
  }

  void signIn() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    ap.signInWithCredential(context, email, password);
  }

  Widget textField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isObscure,
  }) => 
  
  SizedBox(
    width: 500,
  child: TextFormField(
    controller: controller,
    onChanged: (value) => setState(() {controller.text = value;}),
    obscureText: isObscure,
    cursorColor: Theme.of(context).primaryColor,
    style: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Container(
        height: 30,
        width: 30,
        padding: const EdgeInsets.all(10.0),
        child:  Icon(
          icon,
          color: Colors.black54,
          size: 20.0
        )
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  )
  );
}
