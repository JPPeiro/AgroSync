import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';
import 'package:agro_sync/pages/pedir_ingredientes_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
            backgroundColor: Colors.grey[900], // Color de fondo ajustado
            appBar: AppBar(
              title: Text(
                'Detalles de $piensoNombre',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              backgroundColor: Colors.grey[900], // Color de fondo ajustado
            ),
            body: const Center(
              child: CircularProgressIndicator(),
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
          backgroundColor: Colors.grey[900], // Color de fondo ajustado
          appBar: AppBar(
            title: Text(
              'Detalles de $piensoNombre',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.grey[900], // Color de fondo ajustado
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen del pienso
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
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
                  color: Colors.grey[800], // Color de fondo ajustado
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
                                color: Colors.white, // Color de texto ajustado
                              ),
                            ),
                            Text(
                              pienso['nombre'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white, // Color de texto ajustado
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
                                color: Colors.white, // Color de texto ajustado
                              ),
                            ),
                            Text(
                              '${pienso['cantidad']} kilos',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white, // Color de texto ajustado
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tabla de ingredientes
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[800], // Color de fondo ajustado
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowHeight: 40,
                    columns: const [
                      DataColumn(label: Text('Ingrediente', style: TextStyle(color: Colors.white))), // Color de texto ajustado
                      DataColumn(label: Text('Cantidad', style: TextStyle(color: Colors.white))), // Color de texto ajustado
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
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.orange, // Color de texto del botón ajustado
                  ),
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
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.grey[800], // Color de texto del botón ajustado
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (cantidadKilos != null && cantidadKilos!.isNotEmpty) {
                try {
                  // Llamar al método verificarStock
                  final Map<String, dynamic> stockResult = await verificarStock(id, int.parse(cantidadKilos!));
                  print(stockResult);
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
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green, // Color de texto del botón ajustado
            ),
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
            columns: const [
              DataColumn(label: Text('Nombre', style: TextStyle(color: Colors.white))), // Color de texto ajustado
              DataColumn(label: Text('Acción', style: TextStyle(color: Colors.white))), // Color de texto ajustado
            ],
            rows: ingredientesFaltantes.map((ingrediente) {
              print(ingredientesFaltantes);
              String idIngrediente = ingrediente['idIngrediente'];
              String cantidad = ingrediente['cantidad'];

              print(idIngrediente);
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
                          var ingrediente = ingredientes.firstWhere((ingrediente) => ingrediente['id'] == 1, orElse: () => null);
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.orange, // Color de texto del botón ajustado
                      ),
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