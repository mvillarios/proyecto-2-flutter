import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto2/api.dart';
import 'package:proyecto2/widgets/global.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class CrearPublicacion extends StatefulWidget {
  const CrearPublicacion({super.key});

  @override
  State<CrearPublicacion> createState() => _CrearPublicacionState();
}

class _CrearPublicacionState extends State<CrearPublicacion> {

  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  String image1 = '';
  String image2 = '';

  Uint8List? _foto1Bytes;
  Uint8List? _foto2Bytes;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool _showRedBorder = false;
  bool _isLoadingForm = false;

  String obtenerFecha(DateTime fecha) {
    return '${fecha.day}-${fecha.month}-${fecha.year}';
  }

  Future<XFile?> _obtenerImagen() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.camera);

    return imagen;
  }

  Future<String> _imagenABase64(XFile? imagen) async {
    if (imagen == null) {
      return '';
    }

    final bytes = await imagen.readAsBytes();
    final resizedBytes = await _resizeImage(bytes);
    final base64String = base64Encode(resizedBytes);
    return base64String;
  }

  Future<Uint8List> _resizeImage(Uint8List imageBytes) async {
    img.Image image = img.decodeImage(imageBytes)!;

    int width = image.width;
    int height = image.height;

    int minSize = 300;
    int maxSize = 400;

    if (width > height) {
      height = minSize;
      width = maxSize;
    } else {
      width = minSize;
      height = maxSize;
    }

    img.Image resizedImage = img.copyResize(
      image,
      width: width,
      height: height,
    );

    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
        automaticallyImplyLeading: false
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sector'),
                  Form(
                    key: _formKey1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _sectorController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      maxLength: 30,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sector requerido';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {
                          _formKey1.currentState!.validate();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
        
                  const Text('Descripción'),
                  Form(
                    key: _formKey2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      maxLines: 3,
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Descripción requerida';
                        } else if (value.length < 15) {
                          return 'Mínimo 15 caracteres';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[\n\r]'))
                      ],
                      onEditingComplete: () {
                        setState(() {
                          _formKey2.currentState!.validate();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
        
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (_foto1Bytes != null) {
                                  setState(() {
                                    _foto1Bytes = null;
                                  });
                                } else {
                                  try {
                                    // Muestra un indicador de progreso mientras se carga la imagen
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );

                                    final imagen = await _obtenerImagen();
                                    final base64String = await _imagenABase64(imagen);
                                    image1 = base64String;
                                    setState(() {
                                      _foto1Bytes = const Base64Decoder().convert(base64String);
                                    });
                                  } finally {
                                    try{
                                      if (context.mounted){
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      debugPrint('Error al cerrar el dialogo: $e');
                                    }
                                  }
                                }
                              },
                              icon: _foto1Bytes != null
                                  ? const Icon(Icons.delete)
                                  : const Icon(Icons.add_a_photo),
                              label: Text(_foto1Bytes != null ? 'Quitar' : 'Foto 1'),
                            ),
                            const SizedBox(height: 5),
                            _foto1Bytes != null
                                ? Image.memory(
                                    _foto1Bytes!,
                                    width: 100,
                                    height: 100,
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _showRedBorder ? Colors.red : Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                          ],
                        ),
                      ),


                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                // Si hay una imagen, eliminarla
                                if (_foto2Bytes != null) {
                                  setState(() {
                                    _foto2Bytes = null;
                                  });
                                } else {
                                  try {
                                    // Muestra un indicador de progreso mientras se carga la imagen
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );

                                    // Si no hay imagen, cargarla
                                    final imagen = await _obtenerImagen();
                                    final base64String = await _imagenABase64(imagen);
                                    image2 = base64String;
                                    setState(() {
                                      _foto2Bytes = const Base64Decoder().convert(base64String);
                                    });
                                  } finally {
                                    try{
                                      if (context.mounted){
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      debugPrint('Error al cerrar el dialogo: $e');
                                    }
                                  }
                                }
                              },
                              icon: _foto2Bytes != null
                                  ? const Icon(Icons.delete)
                                  : const Icon(Icons.add_a_photo),
                              label: Text(_foto2Bytes != null ? 'Quitar' : 'Foto 2'),
                            ),
                            const SizedBox(height: 5),
                            _foto2Bytes != null
                                ? Image.memory(
                                    _foto2Bytes!,
                                    width: 100,
                                    height: 100,
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                          ],
                        ),
                      )

                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Ir a la pagina main
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.infinity, 40)),
                          ),
                          child: const Text('Volver'),
                        ),
                      ),
                      const SizedBox(width: 10), // Espaciador
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoadingForm
                          ? null
                          : () async{
                            if (_formKey1.currentState!.validate() && _formKey2.currentState!.validate()) {
                              if (_foto1Bytes != null) {
                                try {
                                  setState(() {
                                    _isLoadingForm = true;
                                  });

                                  final response = ApiService.crearPublicacion(
                                    _sectorController.text,
                                    _descripcionController.text,
                                    obtenerFecha(DateTime.now()),
                                    image1,
                                    image2,
                                    Global.token,
                                  );
                                  response.then((value) {
                                    if (value is String && value.isNotEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text(value)));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Publicación creada exitosamente')));
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                  });
                                } catch (e) {
                                  // Manejar cualquier error que pueda ocurrir al obtener el usuario
                                  debugPrint('Error al crear publicación: $e');
                                } finally {
                                  setState(() {
                                    _isLoadingForm = false;
                                  });
                                }
                              } else {
                                //cambia el estado de la variable
                                setState(() {
                                  _showRedBorder = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Foto 1 es obligatoria')));
                              }
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 40)),
                          ),
                          child: _isLoadingForm
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Crear'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}