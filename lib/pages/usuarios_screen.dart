import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../petittions_http.dart';

class UsuariosScreen extends StatelessWidget {
  UsuariosScreen({Key? key}) : super(key: key);

  Widget _buildDataCell(String text) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDataRow(String id, String nombre, String contrasena,
      String permisos) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Editar',
            backgroundColor: Colors.blue,
            icon: Icons.edit,
            onPressed: (context) => print('Editar'),
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
            onPressed: (context) => print('Eliminar'),
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
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
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No se encontraron usuarios.'),
            );
          } else {
            return ListView(
              children: [
                _buildHeaderRow(),
                SizedBox(height: 8), // Espacio entre el encabezado y los datos
                ...snapshot.data!.map((usuario) {
                  return _buildDataRow(
                    usuario['id'].toString(),
                    usuario['nombre'].toString(),
                    usuario['contrasena'].toString(),
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
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
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
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
