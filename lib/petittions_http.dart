import 'dart:convert';
import 'package:http/http.dart' as http;

//Usuarios
Future<List<dynamic>> obtenerUsuarios() async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/usuarios/');

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
  // var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/$id');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/usuarios/$id');

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
  // var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/usuarios/');

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
  // var apiUrl = Uri.parse('http://localhost:8080/api/usuarios/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/usuarios/');

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
  // var apiUrl = Uri.parse('http://localhost:8080/api/piensos/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/piensos/');

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
Future<void> agregarPienso(int piensoId, int cantidadTotal) async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/');

  try {
    var response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'piensoId': piensoId.toString(),
        'cantidadTotal': cantidadTotal.toString(),
      }),
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      print('Pienso agregado exitosamente.');
    } else {
      // Manejar el caso de una solicitud no exitosa
      print('Error en la solicitud, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de red u otros errores
    print('Error: $e');
  }
}
Future<Map<String, dynamic>> verificarStock(int piensoId, int cantidadTotal) async {
  const String apiUrl = 'http://localhost:8080/api/verificar/';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'piensoId': piensoId,
      'cantidadTotal': cantidadTotal,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

//Composiciones
Future<List<dynamic>> obtenerComposiciones() async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/composiciones/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/composiciones/');

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
  // var apiUrl = Uri.parse('http://localhost:8080/api/ingredientes/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/ingredientes/');

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
Future<void> borrarIngrediente(int id) async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/ingredientes/$id');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/ingredientes/$id');

  try {
    var response = await http.delete(apiUrl);
    if (response.statusCode == 200) {
      print('Ingrediente eliminado correctamente');
    } else {
      print('Error al eliminar ingrediente, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al eliminar ingrediente: $e');
  }
}
Future<void> crearIngrediente(Map<String, dynamic> ingrediente) async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/ingredientes/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/ingredientes/');

  try {
    var response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ingrediente),
    );
    if (response.statusCode == 200) {
      print('Ingrediente creado correctamente');
    } else {
      print('Error al crear ingrediente, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al crear ingrediente: $e');
  }
}
Future<void> actualizarIngrediente(Map<String, dynamic> nuevoIngrediente) async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/ingredientes/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/ingredientes/');

  try {
    var response = await http.put(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevoIngrediente),
    );
    if (response.statusCode == 200) {
      print('Ingrediente actualizado correctamente');
    } else {
      print('Error al actualizar ingrediente, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al actualizar ingrediente: $e');
  }
}


//Proveedores
Future<List<dynamic>> obtenerProveedores() async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/proveedores/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/proveedores/');

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
  // var apiUrl = Uri.parse('http://localhost:8080/api/ingredienteproveedor/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/ingredienteproveedor/');

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

//PedidosIngredientes
Future<List<dynamic>> obtenerPedidos() async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/pedidosIngredientes/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/pedidosIngredientes/');

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
Future<void> crearPedido(Map<String, dynamic> pedidos) async {
  // var apiUrl = Uri.parse('http://localhost:8080/api/pedidosIngredientes/');
  var apiUrl = Uri.parse('http://192.168.0.130:8080/api/pedidosIngredientes/');

  try {
    var response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedidos),
    );
    if (response.statusCode == 200) {
      print('Pedido creado correctamente');
    } else {
      print('Error al crear pedido, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al crear pedido: $e');
  }
}
Future<void> aumentarCantidad(int id, String cantidad) async {
  // final url = Uri.parse('http://localhost:8080/api/ingredientesCantidad/?id=$id&cantidad=$cantidad');
  final url = Uri.parse('http://192.168.0.130:8080/api/ingredientesCantidad/?id=$id&cantidad=$cantidad');

  try {
    final response = await http.put(url);

    if (response.statusCode == 200) {
      print('Cantidad de ingrediente actualizada correctamente');
    } else {
      print('Error al actualizar la cantidad del ingrediente');
      print('Código de estado: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
  } catch (e) {
    print('Error en la solicitud HTTP: $e');
  }
}

void main() async {
  List<dynamic> listaUsuarios = await obtenerUsuarios();
  List<dynamic> listaPiensos = await obtenerPiensos();
  List<dynamic> listaComposiciones = await obtenerComposiciones();
  List<dynamic> listaIngredientes = await obtenerIngredientes();
  List<dynamic> listaProveedores = await obtenerProveedores();
  List<dynamic> listaIngredienteProveedor = await obtenerIngredienteProveedor();
  List<dynamic> listaPedidos = await obtenerPedidos();
  final result = await verificarStock(1, 1);

  print('Lista de usuarios: $listaUsuarios');
  print('Lista de piensos: $listaPiensos');
  print('Lista de composiciones: $listaComposiciones');
  print('Lista de ingredientes: $listaIngredientes');
  print('Lista de proveedores: $listaProveedores');
  print('Lista de ingredienteProveedor: $listaIngredienteProveedor');
  print('Lista de pedidos: $listaPedidos');

  print(result);
}