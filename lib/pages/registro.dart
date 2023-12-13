import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto2/api.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();



  bool isEmailValid(String email) {
    // Expresión regular para verificar el formato de un correo electrónico
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Image(
                image: AssetImage('assets/images/udec.jpg'),
                width: 200,
                height: 150,
              )
            ),
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Usuario'),
                  Form(
                    key: _formKey1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _userController,
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
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                        FilteringTextInputFormatter.deny(RegExp(r"\s"))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Usuario requerido';
                        } else if (value.length < 6) {
                          return 'Minimo 6 caracteres';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {
                          _formKey1.currentState?.validate();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text('Correo electrónico'),
                  Form(
                    key: _formKey2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _emailController,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email requerido';
                        } else if (!isEmailValid(value)) {
                          return 'Ingrese un email válido';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {
                          _formKey2.currentState?.validate();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text('Contraseña'),
                  Form(
                    key: _formKey3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _passwordController,
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
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Contraseña requerida';
                        } else if (value.length < 6) {
                          return 'Minimo 6 caracteres';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {
                          _formKey3.currentState?.validate();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text('Confirmar contraseña'),
                  Form(
                    key: _formKey4,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _password2Controller,
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
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirmar contraseña';
                        } else if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {
                          _formKey4.currentState?.validate();
                        });
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      if( _formKey1.currentState!.validate() && _formKey2.currentState!.validate() && _formKey3.currentState!.validate() && _formKey4.currentState!.validate()){
                        try{
                          final response = ApiService.registro(_userController.text, _passwordController.text, _emailController.text);
                          response.then((value) {
                            if (value is String && value.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario registrado con éxito')));
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                          });
                        } catch (e) {
                          debugPrint('Error al registrar usuario: $e');
                        }
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 40)),
                    ),
                    child: const Text('Registrar'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 40)),
                    ),
                    child: const Text('Volver'),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}