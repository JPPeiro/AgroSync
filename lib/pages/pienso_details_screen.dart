import 'package:agro_sync/pages/pedir_ingredientes_screen.dart';
import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';

class PiensoDetailsScreen extends StatelessWidget {
  final String piensoNombre;
  final int id;

  const PiensoDetailsScreen({required this.piensoNombre, required this.id, super.key});

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
            body: const Center(
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
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            title: Text('Detalles de ${pienso['nombre']}'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen del pienso con fondo degradado
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade200, Colors.orange.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/img/Pienso1.png',
                      width: 350,
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Información del pienso
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del pienso
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Nombre:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              pienso['nombre'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Cantidad del pienso
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Cantidad:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${pienso['cantidad']} kilos',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Tabla de ingredientes
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowHeight: 40,
                    columns: const [
                      DataColumn(label: Text('Ingrediente')),
                      DataColumn(label: Text('Cantidad')),
                    ],
                    rows: detallesIngredientes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final detalle = entry.value;
                      return DataRow(
                        color: MaterialStateColor.resolveWith(
                              (states) =>
                          index.isEven ? Colors.grey[200] ?? Colors.grey[200]! : Colors.white,
                        ),
                        cells: [
                          DataCell(
                            Text(
                              detalle['nombre'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${detalle['cantidad']} kilos',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón "Fabricar"
                ElevatedButton(
                  onPressed: () {
                    _mostrarDialogoFabricar(context, id);
                  },
                  child: const Text('Fabricar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
Future<void> _mostrarDialogoFabricar(BuildContext context, int id) async {
  String? cantidadKilos;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Fabricar Pienso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                cantidadKilos = value;
              },
              decoration: const InputDecoration(labelText: 'Cantidad de Kilos'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (cantidadKilos != null && cantidadKilos!.isNotEmpty) {
                try {
                  // Llamar al método verificarStock
                  final Map<String, dynamic> stockResult = await verificarStock(id, int.parse(cantidadKilos!));

                  // Verificar si el resultado de verificarStock es true
                  if (stockResult['result'] == true) {
                    // Llamar al método agregarPienso
                    await agregarPienso(id, int.parse(cantidadKilos!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pienso fabricado correctamente.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    // Mostrar un mensaje si el stock no es suficiente
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No hay suficiente stock para fabricar el pienso.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // Navegar a la pantalla de pedir ingredientes
                   tabla(context, stockResult);
                  }
                } catch (e) {
                  print('Error al fabricar el pienso: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al fabricar el pienso. Por favor, inténtalo de nuevo.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor ingrese la cantidad en kilos.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Fabricar'),
          ),
        ],
      );
    },
  );
}
Future<void> tabla(BuildContext context, Map<String, dynamic> stockResult) async {
  List<dynamic> ingredientesFaltantes = stockResult['data'];

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ingredientes Faltantes'),
        content: SingleChildScrollView(
          child: DataTable(
            columns: [
              const DataColumn(label: Text('Nombre')),
              const DataColumn(label: Text('Acción')),
            ],
            rows: ingredientesFaltantes.map((ingrediente) {
              int idIngrediente = int.parse(ingrediente['idIngrediente']);
              double cantidad = ingrediente['cantidad'];
              print(cantidad);
              return DataRow(
                cells: [
                  DataCell(
                    FutureBuilder(
                      future: obtenerIngredientes(),
                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Obtener la lista de ingredientes
                          List<dynamic> ingredientes = snapshot.data ?? [];
                          // Buscar el nombre del ingrediente a partir del ID
                          var ingrediente = ingredientes.firstWhere((ingrediente) => ingrediente['id'] == idIngrediente, orElse: () => null);
                          // Si se encontró el ingrediente, obtener su nombre
                          String nombreIngrediente = ingrediente != null ? ingrediente['nombre'].toString() : 'Nombre no disponible';

                          return Text(nombreIngrediente);
                        }
                      },
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PedirIngrediente(
                              idIngrediente: idIngrediente,
                              cantidadNecesaria: cantidad,
                            ),
                          ),
                        );
                      },
                      child: const Text('Pedir'),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
