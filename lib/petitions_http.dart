import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> obtenerUsuarios() async {
  var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/');

  try {
    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      // Parsear la respuesta JSON
      var data = jsonDecode(response.body);

      // Devolver la lista de usuarios
      return data;
    } else {
      // Manejar el caso de una solicitud no exitosa
      print('Error en la solicitud, código de estado: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // Manejar errores de red u otros errores
    print('Error: $e');
    return [];
  }
}

void main() async {
  // Ejemplo de cómo utilizar la función obtenerUsuarios
  List<dynamic> listaUsuarios = await obtenerUsuarios();

  // Trabajar con la lista de usuarios
  print('Lista de usuarios: $listaUsuarios');
}
