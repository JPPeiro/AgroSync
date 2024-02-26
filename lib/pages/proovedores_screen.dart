import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../petittions_http.dart';
import 'dialogs/ProveedorDialog.dart';

class ProveedoresScreen extends StatefulWidget {
  ProveedoresScreen({Key? key}) : super(key: key);

  @override
  _ProveedorScreenState createState() => _ProveedorScreenState();
}

class _ProveedorScreenState extends State<ProveedoresScreen> {
  List<dynamic> proveedores = [];

  Widget _buildDataCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDataRow(String id, String nombre) {
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
              final listaProveedores = await showDialog<List<dynamic>>(
                context: context,
                builder: (BuildContext context) {
                  return ProveedorDialog(tipo: 2, id: int.parse(id));
                },
              );
              if (listaProveedores != null && listaProveedores.isNotEmpty) {
                setState(() {
                  proveedores = listaProveedores;
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
            onPressed: (context) => print('Eliminar'),
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
              _buildDataCell(id),
              _buildDataCell(nombre),
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
          'Proveedores',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerProveedores(),
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
              child: Text('No se encontraron proveedores.'),
            );
          } else {
            proveedores = snapshot.data!;
            return ListView(
              children: [
                _buildHeaderRow(),
                const SizedBox(height: 8),
                ...proveedores.map((proveedor) {
                  return _buildDataRow(
                    proveedor['id'].toString(),
                    proveedor['nombre'].toString(),
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
      color: Colors.teal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeaderCell('Id'),
            _buildHeaderCell('Nombre'),
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
