import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaginaDetalleImagen extends StatelessWidget {
  final String imagen;

  const PaginaDetalleImagen({super.key, required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Imagen'),
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Image.memory(
                  base64StringToBytes(imagen),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Volver a la página de detalle
                },
                child: const Text('Volver al Detalle'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Uint8List base64StringToBytes(String base64String) {
    return base64.decode(base64String);
  }
}
