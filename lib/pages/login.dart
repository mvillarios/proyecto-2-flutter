import 'package:flutter/material.dart';
import 'package:proyecto2/widgets/textfield.dart';
import 'package:proyecto2/api.dart';
import 'package:proyecto2/widgets/global.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _InicioState();
}

class _InicioState extends State<Login> {

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

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
              ),
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
                  buildTextField(_userController, "Usuario", false),
                  buildTextField(_passwordController, "Contraseña", true),

                  ElevatedButton(
                    onPressed: isLoading
                    ? null
                    : () async {
                      // Si no estan vacios
                      if(_userController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                        try{
                          setState(() {
                            isLoading = true;
                          });

                          final response = ApiService.login(_userController.text, _passwordController.text);

                          response.then((value) {
                            if (value is String && value.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                            }else{
                              // Guardar token
                              Global.token = value['access_token'];
                              //debugPrint(Global.token);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicio de sesión exitoso')));
                              Navigator.pushNamed(context, '/home');
                            }
                          });
                        } catch (e) {
                          debugPrint('Error al obtener el usuario: $e');
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, llene todos los campos')));
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 40)),
                    ),
                    child: isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFF6200EE),
                        strokeWidth: 3,
                      ),
                    )
                    : const Text('Ingresar'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/registro');
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 40)),
                    ),
                    child: const Text('Registrarse'),
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