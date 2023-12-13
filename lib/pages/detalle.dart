import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto2/pages/imagen.dart';

class Detalle extends StatefulWidget {
  const Detalle({Key? key}) : super(key: key);

  @override
  State<Detalle> createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String id = args?['_id'] ?? '';
    final String sector = args?['sector'] ?? '';
    final String descripcion = args?['descripcion'] ?? '';
    final String fecha = args?['fecha'] ?? '';
    final String imagen1 = args?['imagen1'] ?? '';
    final String imagen2 = args?['imagen2'] ?? '';
    final String nombreCreador = args?['nombreCreador'] ?? '';

    Uint8List base64StringToBytes(String base64String) {
      return base64.decode(base64String);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sector,
          style: const TextStyle(
            fontSize: 20,
          ),
          
        ),
        automaticallyImplyLeading: false
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descricion
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                descripcion,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            // Row de imagenes
            Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: imagen1.isNotEmpty, // Mostrar solo si hay una imagen1
                    child: GestureDetector(
                      onTap: () {
                        // Navegar a la página de detalle de la imagen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaginaDetalleImagen(imagen: imagen1),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 10, top: 20),
                        child: Image.memory(base64StringToBytes(imagen1), height: 150),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: imagen2.isNotEmpty, // Mostrar solo si hay una imagen2
                    child: GestureDetector(
                      onTap: () {
                        // Navegar a la página de detalle de la imagen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaginaDetalleImagen(imagen: imagen2),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 20, top: 20),
                        child: Image.memory(base64StringToBytes(imagen2), height: 150),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Creador y fecha
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Subido por ',
                            style: TextStyle(
                              color: Colors.black, // Puedes personalizar el color si es necesario
                            ),
                          ),
                          TextSpan(
                            text: nombreCreador,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Puedes personalizar el color si es necesario
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      fecha,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

            // Boton para volver
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 40)),
                ),
                child: const Text('Volver'),
              ),
            )

          ],
        ),
      ),
    );
  }
}
