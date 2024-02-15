import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../petittions_http.dart';
import 'dialogs/UsuarioDialog.dart';
import 'forms/formulario_usuario_screen.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<dynamic> usuarios = [];


  Future<void> actualizar(int id) async {
    try {
      // Llama a la función para eliminar el usuario desde el servidor
      await borrarUsuario(id);
      // Actualiza la lista de usuarios eliminando el usuario borrado
      setState(() {
        usuarios.removeWhere((usuario) => usuario['id'] == id);
      });
    } catch (e) {
      print('Error al borrar el usuario: $e');
    }
  }
  // Método para construir una celda de datos
  Widget _buildDataCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Método para construir una fila de datos
  Widget _buildDataRow(String id, String nombre, String contrasena, String permisos) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Editar',
            backgroundColor: Colors.blue,
            icon: Icons.edit,
            onPressed: (context) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => FormularioScreen(userId: int.parse(id)),
              //   ),
              // ).then((listaUsuarios) {
              //   if (listaUsuarios != null) {
              //     setState(() {
              //       usuarios = listaUsuarios;
              //     });
              //   }
              // });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UsuarioDialog(tipo: 2,id: int.parse(id));
                },
              );
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Eliminar',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) {
              actualizar(int.parse(id));
            },
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDataCell(id),
              _buildDataCell(nombre),
              _buildDataCell(contrasena),
              _buildDataCell(permisos),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Usuarios'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UsuarioDialog(tipo: 1,);
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron usuarios.'),
            );
          } else {
            // Almacena los usuarios en la lista usuarios
            usuarios = snapshot.data!;
            return ListView(
              children: [
                _buildHeaderRow(),
                const SizedBox(height: 8), // Espacio entre el encabezado y los datos
                ...usuarios.map((usuario) {
                  return _buildDataRow(
                    usuario['id'].toString(),
                    usuario['nombre'].toString(),
                    usuario['password'].toString(),
                    usuario['permisos'].toString(),
                  );
                }),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeaderCell('ID'),
            _buildHeaderCell('Nombre'),
            _buildHeaderCell('Contraseña'),
            _buildHeaderCell('Permisos'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
