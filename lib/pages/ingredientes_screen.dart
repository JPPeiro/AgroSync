import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../petittions_http.dart';
import 'dialogs/IngredienteDialog.dart';

class IngredientesScreen extends StatefulWidget {
  const IngredientesScreen({super.key});

  @override
  _IngredientesScreenState createState() => _IngredientesScreenState();
}

class _IngredientesScreenState extends State<IngredientesScreen> {
  List<dynamic> ingredientes = [];

  Future<void> actualizar(int id) async {
    try {
      await borrarIngrediente(id);
      setState(() {
        ingredientes.removeWhere((ingrediente) => ingrediente['id'] == id);
      });
    } catch (e) {
      print('Error al borrar el ingrediente: $e');
    }
  }

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
              onPressed: (BuildContext context) async {
                final listaIngredientes = await showDialog<List<dynamic>>(
                  context: context,
                  builder: (BuildContext context) {
                    return IngredienteDialog(tipo: 2, id: int.parse(id));
                  },
                );
                if (listaIngredientes != null && listaIngredientes.isNotEmpty) {
                  setState(() {
                    ingredientes = listaIngredientes;
                  });
                }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Ingredientes',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: () async {
              final listaIngredientes = await showDialog<List<dynamic>>(
                context: context,
                builder: (BuildContext context) {
                  return IngredienteDialog(tipo: 1);
                },
              );
              if (listaIngredientes != null && listaIngredientes.isNotEmpty) {
                setState(() {
                  ingredientes = listaIngredientes;
                });
              }
            },
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerIngredientes(),
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
              child: Text('No se encontraron ingredientes.'),
            );
          } else {
            ingredientes = snapshot.data!;
            return ListView(
              children: [
                _buildHeaderRow(),
                const SizedBox(height: 8),
                ...ingredientes.map((ingrediente) {
                  // Limitar la cantidad a dos decimales
                  double cantidad = double.parse(ingrediente['cantidad'].toString());
                  String cantidadFormateada = cantidad.toStringAsFixed(2);

                  return _buildDataRow(
                    ingrediente['id'].toString(),
                    ingrediente['nombre'].toString(),
                    cantidadFormateada, // Usar la cantidad formateada
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
      color: Colors.deepPurple,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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