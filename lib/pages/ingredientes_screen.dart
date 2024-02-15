import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../petittions_http.dart';
import 'dialogs/IngredienteDialog.dart';

class IngredientesScreen extends StatelessWidget {
  IngredientesScreen({Key? key}) : super(key: key);

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

  Widget _buildDataRow(String id, String nombre, String inventario) {
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return IngredienteDialog(tipo: 2,id: int.parse(id));
                },
              );
            }
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
              _buildDataCell(inventario),
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
        title: Text('Ingredientes'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade300, Colors.purple.shade500],
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
                  return IngredienteDialog(tipo: 1,);
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerIngredientes(),
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
              child: Text('No se encontraron proveedores.'),
            );
          } else {
            return ListView(
              children: [
                _buildHeaderRow(),
                SizedBox(height: 8), // Espacio entre el encabezado y los datos
                ...snapshot.data!.map((proveedor) {
                  return _buildDataRow(
                    proveedor['id'].toString(),
                    proveedor['nombre'].toString(),
                    proveedor['cantidad'].toString()+" kilos",
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
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeaderCell('ID'),
            _buildHeaderCell('Nombre'),
            _buildHeaderCell('Inventario'),
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
