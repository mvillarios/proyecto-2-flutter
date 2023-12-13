import 'package:flutter/material.dart';
import 'package:proyecto2/pages/crear_publicacion.dart';
import 'package:proyecto2/pages/detalle.dart';
import 'package:proyecto2/pages/login.dart';
import 'package:proyecto2/pages/registro.dart';
import 'package:proyecto2/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/registro': (context) => const Registro(),
        '/home': (context) => const Home(),
        '/detalle': (context) => const Detalle(),
        '/crear_publicacion': (context) => const CrearPublicacion(),
      },
    );
  }
}