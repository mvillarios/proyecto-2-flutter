// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyecto2/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<dynamic> publicaciones = [];
  late Map<String, String> usuarioCache = {};

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _loadPublicacionesFromCache();
    _loadUsuariosFromCache();
  }

  Future<void> _loadPublicacionesFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cachedData = prefs.getString('publicaciones') ?? '';

    if (cachedData.isNotEmpty) {
      setState(() {
        publicaciones = List<Map<String, dynamic>>.from(json.decode(cachedData));
      });
    }
    
    if (isFirstTime) {
      isFirstTime = false;
      await _loadPublicaciones();
    }

  }

  Future<void> _savePublicacionesToCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('publicaciones', json.encode(publicaciones));
  }

  Future<void> _loadUsuariosFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cachedData = prefs.getString('usuarios') ?? '';

    if (cachedData.isNotEmpty) {
      setState(() {
        usuarioCache = Map<String, String>.from(json.decode(cachedData));
      });
    }
  }

  Future<void> _saveUsuariosToCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuarios', json.encode(usuarioCache));
  }

  Future<void> _loadPublicaciones() async {
    try {
      final response = await ApiService.allPublicaciones();

      if (context != null && context.mounted) {
        if (response is String && response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
        } else {
          setState(() {
            publicaciones = response['publicaciones'] is List ? List.from(response['publicaciones']) : [];
            publicaciones = publicaciones.reversed.toList();
          });

          _savePublicacionesToCache();
        }
      }
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la carga de publicaciones
      debugPrint('Error al cargar publicaciones: $e');
    }
  }

  Future<void> _updatePublicaciones() async {
    await _loadPublicaciones();
  }

  Future<String> _getUsuario(String id) async {
    try {

      if (usuarioCache.containsKey(id)) {
        return usuarioCache[id]!;
      }

      final response = await ApiService.usurioId(id);

      if (context != null && context.mounted) {
        if (response is String && response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
        } else {
          final nombreCreador = response['usuario']['username'].toString();
          
          usuarioCache[id] = nombreCreador;
          _saveUsuariosToCache();

          return nombreCreador;
        }
      }
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir al obtener el usuario
      debugPrint('Error al obtener el usuario: $e');
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista'),
        automaticallyImplyLeading: false
      ),
      body: RefreshIndicator(
        onRefresh: _updatePublicaciones,
        child: Scrollbar(
          child: publicaciones.isEmpty ? const Center(child: Text('No hay publicaciones'))  
          : ListView.builder(
            itemCount: publicaciones.length,
            itemBuilder: (context, index){
              final publicacion = publicaciones[index];
              
              return FutureBuilder<String>(
                future: _getUsuario(publicacion['idCreador']),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Container();
                  } else if (snapshot.hasError){
                    return const Text('Error al cargar');
                  } else{
                    final nombreCreador = snapshot.data ?? '';
                    final fecha = publicacion['fecha'];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        title: Text(
                          publicacion['sector'],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'por ',
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
                                '$fecha',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.pushReplacementNamed(
                            context,
                            '/detalle',
                            arguments: {
                              '_id': publicacion['_id'],
                              'sector': publicacion['sector'],
                              'descripcion': publicacion['descripcion'],
                              'fecha': publicacion['fecha'],
                              'imagen1': publicacion['imagen1'],
                              'imagen2': publicacion['imagen2'],
                              'nombreCreador': nombreCreador,
                            },
                          );
                        },
                        
                      ),
                    );
                  }
                },
              );
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.pushReplacementNamed(context, '/crear_publicacion');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}