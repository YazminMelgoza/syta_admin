import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syta_admin/screens/login_screen.dart';
import 'package:syta_admin/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:syta_admin/provider/auth_provider.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Seguimiento de mi vehículo',
        theme: ThemeData(
          fontFamily: 'Rubik',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 9, 8, 99),
            primary: const Color.fromARGB(255, 9, 8, 99),
            secondary: const Color.fromARGB(255, 255, 115, 29),
            surface: const Color.fromARGB(255, 255, 255, 255),
            background: const Color.fromARGB(255, 255, 247, 233),
            error: const Color.fromARGB(255, 255, 0, 0),
            onPrimary: const Color.fromARGB(255, 255, 255, 255),
            onSecondary: const Color.fromARGB(255, 0, 0, 0),
            onSurface: const Color.fromARGB(255, 0, 0, 0),
            onBackground: const Color.fromARGB(255, 0, 0, 0),
            onError: const Color.fromARGB(255, 255, 255, 255),
            brightness: Brightness.light
          )
          
        ),
        home: const LoginScreen(),
      )
    );
  }
}
