import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> obtenerUsuarios() async {
  // Construir la URL de la API utilizando Uri.parse
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

Future<List<dynamic>> obtenerPiensos() async {
  // Construir la URL de la API utilizando Uri.parse
  var apiUrl = Uri.parse('http://localhost:8080/api/piensos/');

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

Future<List<dynamic>> obtenerComposiciones() async {
  // Construir la URL de la API utilizando Uri.parse
  var apiUrl = Uri.parse('http://localhost:8080/api/composiciones/');

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
  List<dynamic> listaUsuarios = await obtenerUsuarios();
  List<dynamic> listaPiensos = await obtenerPiensos();
  List<dynamic> listaComposiciones = await obtenerComposiciones();

  print('Lista de usuarios: $listaUsuarios');
  print('Lista de piensos: $listaPiensos');
  print('Lista de composiciones: $listaComposiciones');
}