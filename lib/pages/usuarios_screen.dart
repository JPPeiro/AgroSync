import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../petittions_http.dart';
import 'dialogs/UsuarioDialog.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<dynamic> usuarios = [];

  Future<void> actualizar(int id) async {
    try {
      await borrarUsuario(id);
      setState(() {
        usuarios.removeWhere((usuario) => usuario['id'] == id);
      });
    } catch (e) {
      print('Error al borrar el usuario: $e');
    }
  }

  Widget _buildDataCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white), // Cambio de color del texto
        ),
      ),
    );
  }

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
            onPressed: (BuildContext context) async {
              final listaUsuarios = await showDialog<List<dynamic>>(
                context: context,
                builder: (BuildContext context) {
                  return UsuarioDialog(tipo: 2, id: int.parse(id));
                },
              );
              if (listaUsuarios != null && listaUsuarios.isNotEmpty) {
                setState(() {
                  usuarios = listaUsuarios;
                });
              }
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.grey[900],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: () async {
              final listaUsuarios = await showDialog<List<dynamic>>(
                context: context,
                builder: (BuildContext context) {
                  return UsuarioDialog(tipo: 1);
                },
              );
              if (listaUsuarios != null && listaUsuarios.isNotEmpty) {
                setState(() {
                  usuarios = listaUsuarios;
                });
              }
            },
            icon: const Icon(Icons.add),
            color: Colors.white,
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
            usuarios = snapshot.data!;
            return ListView(
              children: [
                _buildHeaderRow(),
                const SizedBox(height: 8),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.indigo, // Cambio de color del fondo de la cabecera
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.indigo, // Cambio de color del fondo de la cabecera
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
