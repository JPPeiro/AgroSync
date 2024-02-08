import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';

class PiensoDetailsScreen extends StatelessWidget {
  final String piensoNombre;

  const PiensoDetailsScreen({required this.piensoNombre, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([obtenerPiensos(), obtenerComposiciones(), obtenerIngredientes()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Detalles de $piensoNombre'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Detalles de $piensoNombre'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Desestructurar la lista de respuestas
        final List<dynamic> responses = snapshot.data!;
        final List<dynamic> piensos = responses[0];
        final List<dynamic> composiciones = responses[1];
        final List<dynamic> ingredientes = responses[2];

        // Buscar el pienso por su nombre
        final pienso = piensos.firstWhere(
              (pienso) => pienso['nombre'].toString() == piensoNombre,
          orElse: () => null,
        );

        if (pienso == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Detalles de $piensoNombre'),
            ),
            body: Center(
              child: Text('No se encontraron detalles para $piensoNombre.'),
            ),
          );
        }

        // Obtener el ID del pienso y filtrar las composiciones por ese ID
        final piensoId = pienso['id'];
        final composicionesFiltradas = composiciones.where((composicion) => composicion['idPienso'] == piensoId);

        // Construir la lista de ingredientes con sus cantidades
        final detallesIngredientes = composicionesFiltradas.map((composicion) {
          final ingredienteId = composicion['idIngrediente'];
          final cantidad = composicion['cantidad'];

          // Buscar el nombre del ingrediente por su ID
          final ingrediente = ingredientes.firstWhere(
                (ingrediente) => ingrediente['id'] == ingredienteId,
            orElse: () => null,
          );

          if (ingrediente != null) {
            final nombreIngrediente = ingrediente['nombre'];
            return {'nombre': nombreIngrediente, 'cantidad': cantidad};
          } else {
            return {'nombre': '', 'cantidad': ''};
          }
        }).toList();

        // Aquí puedes mostrar los detalles del pienso en una tabla
        return Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            title: Text('Detalles de ${pienso['nombre']}'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/img/Pienso1.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                // Tabla para el nombre del pienso y la cantidad
                DataTable(
                  columnSpacing: 16,
                  columns: [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Cantidad')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('${pienso['nombre']}')),
                      DataCell(Text('${pienso['cantidad']}')),
                    ]),
                  ],
                ),

                // Tabla para los ingredientes
                DataTable(
                  columnSpacing: 16,
                  columns: [
                    DataColumn(label: Text('Ingrediente')),
                    DataColumn(label: Text('Cantidad')),
                  ],
                  rows: detallesIngredientes.map((detalle) {
                    return DataRow(cells: [
                      DataCell(Text(detalle['nombre'])),
                      DataCell(Text('${detalle['cantidad']} gramos')),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
