import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService{

  static const urlBase = 'https://dbc2-2800-150-107-db6-c863-4cf8-34a5-62be.ngrok-free.app';

  static Future<dynamic> registro(String username, String password, String email) async{
    
    final response = await http.post(
      Uri.parse('$urlBase/usuarios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> login(String username, String password) async{
    final response = await http.post(
      Uri.parse('$urlBase/usuarios/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'username': username,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> allUsuarios() async{
    final response = await http.get(
      Uri.parse('$urlBase/usuarios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> usurioId(String id) async{
    final response = await http.get(
      Uri.parse('$urlBase/usuarios/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  // Publicaciones

  static Future<dynamic> crearPublicacion(String sector, String descripcion, String fecha, String imagen1, String imagen2, String token) async{
    final response = await http.post(
      Uri.parse('$urlBase/publicaciones'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String,dynamic>{
        'sector': sector,
        'descripcion': descripcion,
        'fecha': fecha,
        'imagen1': imagen1,
        'imagen2': imagen2,
        'idCreador': ''
      }),
    );

    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> allPublicaciones() async{
    final response = await http.get(
      Uri.parse('$urlBase/publicaciones'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> publicacionId(String id) async{
    final response = await http.get(
      Uri.parse('$urlBase/publicaciones/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  // Comentarios
  static Future<dynamic> crearComentario(String comentario, String idPublicacion, String token) async{
    final response = await http.post(
      Uri.parse('$urlBase/comentarios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String,dynamic>{
        'comentario': comentario,
        'idPublicacion': idPublicacion,
      }),
    );

    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> allComentarios() async{
    final response = await http.get(
      Uri.parse('$urlBase/comentarios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> comentarioId(String id) async{
    final response = await http.get(
      Uri.parse('$urlBase/comentarios/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  // Funcion que obtiene todos los comentarios de una publicacion
  static Future<dynamic> comentariosPublicacion(String idPublicacion) async{
    final response = await http.get(
      Uri.parse('$urlBase/comentarios/publicacion/$idPublicacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  // Reacciones
  static Future<dynamic> crearReaccion(bool tipo, String idPublicacion, String token) async{
    final response = await http.post(
      Uri.parse('$urlBase/reacciones'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String,dynamic>{
        'tipo': tipo,
        'idCreador': '',
        'idPublicacion': idPublicacion
      }),
    );

    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> allReacciones() async{
    final response = await http.get(
      Uri.parse('$urlBase/reacciones'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  static Future<dynamic> reaccionId(String id) async{
    final response = await http.get(
      Uri.parse('$urlBase/reacciones/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }


  // Funcion que obtiene todas las reacciones de una publicacion
  static Future<dynamic> reaccionesPublicacion(String idPublicacion) async{
    final response = await http.get(
      Uri.parse('$urlBase/reacciones/publicacion/$idPublicacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  // Funcion que obtiene todas las reacciones de un usuario
  static Future<dynamic> reaccionUsuario(String token, String idPublicacion) async{
    final response = await http.get(
      Uri.parse('$urlBase/reaccion/usuario/$idPublicacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }


  // Funcion que modifica una reaccion por su id
  static Future<dynamic> modificarReaccion(String id, bool tipo) async{
    final response = await http.put(
      Uri.parse('$urlBase/reacciones/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,dynamic>{
        'tipo': tipo,
      }),
    );

    if(response.statusCode == 200){
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

  // Eliminar reaccion
  static Future<dynamic> eliminarReaccion(String id) async{
    final response = await http.delete(
      Uri.parse('$urlBase/reacciones/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      // recibir el mensaje
      return jsonDecode(response.body)['detail'];
    }
  }

}