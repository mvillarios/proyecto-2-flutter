import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService{

  static const urlBase = 'https://fe1c-2800-150-107-db6-442a-e7b6-6e3b-8d58.ngrok-free.app';

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

}