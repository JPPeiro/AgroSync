import 'dart:convert';
import 'package:http/http.dart' as http;
//Usuarios
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
Future<void> borrarUsuario(int id) async {
  var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/$id');

  try {
    var response = await http.delete(apiUrl);
    if (response.statusCode == 200) {
      print('Usuario eliminado correctamente');
    } else {
      print('Error al eliminar usuario, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al eliminar usuario: $e');
  }
}
Future<void> crearUsuario(Map<String, dynamic> usuario) async {
  var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/');

  try {
    var response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario),
    );
    if (response.statusCode == 200) {
      print('Usuario creado correctamente');
    } else {
      print('Error al crear usuario, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al crear usuario: $e');
  }
}
Future<void> actualizarUsuario(Map<String, dynamic> nuevoUsuario) async {
  var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/');

  try {
    var response = await http.put(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevoUsuario),
    );
    if (response.statusCode == 200) {
      print('Usuario actualizado correctamente');
    } else {
      print('Error al actualizar usuario, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al actualizar usuario: $e');
  }
}


//Pienso
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


//Composiciones
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


//Ingredientes
Future<List<dynamic>> obtenerIngredientes() async {
  // Construir la URL de la API utilizando Uri.parse
  var apiUrl = Uri.parse('http://localhost:8080/api/ingredientes/');

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


//Proveedores
Future<List<dynamic>> obtenerProveedores() async {
  // Construir la URL de la API utilizando Uri.parse
  var apiUrl = Uri.parse('http://localhost:8080/api/proveedores/');

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


//Ingredientes Proveedor
Future<List<dynamic>> obtenerIngredienteProveedor() async {
  // Construir la URL de la API utilizando Uri.parse
  var apiUrl = Uri.parse('http://localhost:8080/api/ingredienteproveedor/');

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
  List<dynamic> listaIngredientes = await obtenerIngredientes();
  List<dynamic> listaProveedores = await obtenerProveedores();
  List<dynamic> listaIngredienteProveedor = await obtenerIngredienteProveedor();


  print('Lista de usuarios: $listaUsuarios');
  print('Lista de piensos: $listaPiensos');
  print('Lista de composiciones: $listaComposiciones');
  print('Lista de ingredientes: $listaIngredientes');
  print('Lista de proveedores: $listaProveedores');
  print('Lista de ingredienteProveedor: $listaIngredienteProveedor');
}