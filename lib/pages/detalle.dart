import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto2/pages/imagen.dart';
import 'package:proyecto2/widgets/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto2/api.dart';

class Detalle extends StatefulWidget {
  const Detalle({Key? key}) : super(key: key);

  @override
  State<Detalle> createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {

  List<bool> isSelected = [false, false];
  int _numReaccionesSi = 0;
  int _numReaccionesNo = 0;
  Map<String, dynamic> reaccionMap = {};

  bool isFirstTime = true;


  Future<void> _loadReaccionesFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cachedData = prefs.getString('reacciones') ?? '';

    if (cachedData.isNotEmpty) {
      final Map<String, dynamic> cachedReacciones = json.decode(cachedData);
      setState(() {
        _numReaccionesSi = cachedReacciones['si'];
        _numReaccionesNo = cachedReacciones['no'];
      });
    }

    if (isFirstTime) {
      isFirstTime = false;
      await _loadReacciones();
    }

  }

  Future<void> _saveReaccionesToCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reacciones', json.encode({'si': _numReaccionesSi, 'no': _numReaccionesNo}));
  }

  Future<void> _loadReacciones() async {
    debugPrint("Cargando reacciones");
    try {
      final Map<String, dynamic> reacciones = await ApiService.reaccionesPublicacion(_idPublicacion);

      if (reacciones.containsKey('reacciones')) {
        final List<dynamic> reaccionesList = reacciones['reacciones'];

        int countSi = 0;
        int countNo = 0;

        for (final Map<String, dynamic> reaccion in reaccionesList) {
          if (reaccion['tipo']) {
            countSi++;
          } else {
            countNo++;
          }
        }

        setState(() {
          _numReaccionesSi = countSi;
          _numReaccionesNo = countNo;
        });

        await _saveReaccionesToCache();
      }
    } catch (e) {
      debugPrint('Error al cargar reacciones: $e');
    }
  }

  // Funcion que busca la reaccion de un usuario y ve si ya reacciono a la publicacion
  Future<void> _loadReaccion() async {
    try {
      Map<String, dynamic> reaccion = await ApiService.reaccionUsuario(Global.token, _idPublicacion);
      //Si ya reacciono se asigna el valor a isSelected
      if (reaccion.containsKey('reaccion')) {
        reaccionMap = reaccion['reaccion'];
        setState(() {
          if (reaccionMap['tipo']) {
            isSelected[0] = true;
          } else {
            isSelected[1] = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Error al cargar reaccion: $e');
    }
  }

  Future<void> crearReaccion(bool tipo) async {
    try {
      Map<String, dynamic> reaccion = await ApiService.crearReaccion(tipo, _idPublicacion, Global.token);
      reaccionMap = {"_id": reaccion['id']};
    } catch (e) {
      debugPrint('Error al crear reaccion: $e');
    }
  }

  Future<void> modificarReaccion(String id, bool tipo) async {
    try {
      await ApiService.modificarReaccion(id, tipo);
    } catch (e) {
      debugPrint('Error al modificar reaccion: $e');
    }
  }

  Future<void> eliminarReaccion(String id) async {
    try {
      await ApiService.eliminarReaccion(id);
      reaccionMap = {};

    } catch (e) {
      debugPrint('Error al eliminar reaccion: $e');
    }
  }

  Uint8List base64StringToBytes(String base64String) {
    return base64.decode(base64String);
  }

  @override
  void initState() {
    super.initState();
    _loadReaccionesFromCache();

  }

  String _idPublicacion = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Asegúrate de que args no sea nulo antes de intentar acceder a sus valores
    if (args != null) {
      _idPublicacion = args['_id'] ?? '';
      _loadReaccion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String sector = args?['sector'] ?? '';
    final String descripcion = args?['descripcion'] ?? '';
    final String fecha = args?['fecha'] ?? '';
    final String imagen1 = args?['imagen1'] ?? '';
    final String imagen2 = args?['imagen2'] ?? '';
    final String nombreCreador = args?['nombreCreador'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            sector,
            style: const TextStyle(
              fontSize: 20,
            ),
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
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: nombreCreador,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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

            // Reacciones
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ToggleButtons(
                          isSelected: [isSelected[0]],
                          onPressed: (int index) {
                            setState(() {
                              isSelected[0] = !isSelected[0];
                              isSelected[1] = false;

                              // Si reaccionMap es vacio, es porque no ha reaccionado
                              if (reaccionMap.isEmpty) {
                                crearReaccion(true).then((value) => _loadReacciones());
                              } else if (isSelected[0] == false) {
                                modificarReaccion(reaccionMap['_id'], false).then((value) => _loadReacciones());
                              } else {
                                modificarReaccion(reaccionMap['_id'], true).then((value) => _loadReacciones());
                              }

                              // Si los dos son false, se borra la reaccion
                              if (isSelected[0] == false && isSelected[1] == false) {
                                eliminarReaccion(reaccionMap['_id']).then((value) => _loadReacciones());
                              }
                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          selectedColor: Colors.black, // Cambia el color cuando está seleccionado
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Sigue ahí',
                                      style: TextStyle(
                                        color: Colors.black,
                                      )
                                    ),
                                    TextSpan(
                                      text: ' ($_numReaccionesSi)',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        ToggleButtons(
                          isSelected: [isSelected[1]],
                          onPressed: (int index) {
                            // Ya no esta
                            setState(() {
                              isSelected[1] = !isSelected[1];
                              isSelected[0] = false;

                              // Si reaccionMap es vacio, es porque no ha reaccionado
                              if (reaccionMap.isEmpty) {
                                crearReaccion(false). then((value) => _loadReacciones());
                              } else if (isSelected[1] == false) {
                                modificarReaccion(reaccionMap['_id'], true).then((value) => _loadReacciones());
                              } else {
                                modificarReaccion(reaccionMap['_id'], false).then((value) => _loadReacciones());
                              }

                              // Si los dos son false, se borra la reaccion
                              if (isSelected[0] == false && isSelected[1] == false) {
                                eliminarReaccion(reaccionMap['_id']).then((value) => _loadReacciones());
                              } 

                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          
                          selectedColor: Colors.black, // Cambia el color cuando está seleccionado
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Ya no está',
                                      style: TextStyle(
                                        color: Colors.black,
                                      )
                                    ),
                                    TextSpan(
                                      text: ' ($_numReaccionesNo)',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
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
