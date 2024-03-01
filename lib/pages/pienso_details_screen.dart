import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';
import 'package:agro_sync/pages/pedir_ingredientes_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PiensoDetailsScreen extends StatefulWidget {
  final String piensoNombre;
  final int id;
  final String imagen;

  const PiensoDetailsScreen({required this.piensoNombre, required this.id, required this.imagen, Key? key}) : super(key: key);

  @override
  _PiensoDetailsScreenState createState() => _PiensoDetailsScreenState();
}

class _PiensoDetailsScreenState extends State<PiensoDetailsScreen> {
  late List<dynamic> _detallesIngredientes = [];
  String _cantidadPienso = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final List<dynamic> responses = await Future.wait(
        [obtenerPiensos(), obtenerComposiciones(), obtenerIngredientes()]);
    final List<dynamic> piensos = responses[0];
    final List<dynamic> composiciones = responses[1];
    final List<dynamic> ingredientes = responses[2];
    final pienso = piensos.firstWhere((pienso) =>
    pienso['nombre'].toString() == widget.piensoNombre, orElse: () => null);
    final piensoId = pienso != null ? pienso['id'] : null;

    if (piensoId != null) {
      final composicionesFiltradas = composiciones.where((
          composicion) => composicion['idPienso'] == piensoId);

      _detallesIngredientes = composicionesFiltradas.map((composicion) {
        final ingredienteId = composicion['idIngrediente'];
        final cantidad = composicion['cantidad'];

        final ingrediente = ingredientes.firstWhere((
            ingrediente) => ingrediente['id'] == ingredienteId,
            orElse: () => null);

        if (ingrediente != null) {
          final nombreIngrediente = ingrediente['nombre'];
          return {'nombre': nombreIngrediente, 'cantidad': cantidad};
        } else {
          return {'nombre': '', 'cantidad': ''};
        }
      }).toList();

      setState(() {
        _cantidadPienso = pienso['cantidad'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          widget.piensoNombre,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/img/${widget.imagen}',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nombre:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.piensoNombre,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cantidad:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$_cantidadPienso kilos',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.grey[800],
              child: DataTable(
                columnSpacing: 16,
                headingRowHeight: 40,
                columns: const [
                  DataColumn(label: Text(
                      'Ingrediente', style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text(
                      'Cantidad', style: TextStyle(color: Colors.white))),
                ],
                rows: _detallesIngredientes
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final detalle = entry.value;
                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                          (states) =>
                      index.isEven
                          ? Colors.grey[200] ?? Colors.grey[200]!
                          : Colors.white,
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
            ElevatedButton(
              onPressed: () {
                _mostrarDialogoFabricar(context, widget.id);
              },
              child: const Text('Fabricar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
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
                decoration: const InputDecoration(
                    labelText: 'Cantidad de Kilos'),
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
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[800],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (cantidadKilos != null && cantidadKilos!.isNotEmpty) {
                  try {
                    final Map<String,
                        dynamic> stockResult = await verificarStock(
                        id, int.parse(cantidadKilos!));
                    if (stockResult['result'] == true) {
                      await agregarPienso(id, int.parse(cantidadKilos!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pienso fabricado correctamente.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop();
                      _loadData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'No hay suficiente stock para fabricar el pienso.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      _mostrarDialogoIngredientes(context, stockResult);
                    }
                  } catch (e) {
                    print('Error al fabricar el pienso: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Error al fabricar el pienso. Por favor, inténtalo de nuevo.'),
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
                foregroundColor: Colors.white,
                backgroundColor: Colors
                    .green, // Color de texto del botón ajustado
              ),
            ),

          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoIngredientes(BuildContext context, Map<String, dynamic> stockResult) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingredientes Faltantes'),
          content: SingleChildScrollView(
              child: _buildTable(context, stockResult['ingredientList']),
          ),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context,
      List<dynamic> ingredientesFaltantes) {
    return DataTable(
      columns: const [
        DataColumn(
            label: Text('Nombre', style: TextStyle(color: Colors.black))),
        DataColumn(
            label: Text('Acción', style: TextStyle(color: Colors.black))),
      ],
      rows: ingredientesFaltantes.map((ingrediente) {
        String idIngrediente = ingrediente['idIngrediente'] ?? "";
        double cantidad = ingrediente['cantidad'] ?? 0;

        return DataRow(
          cells: [
            DataCell(
              FutureBuilder(
                future: obtenerIngredientes(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dynamic> ingredientes = snapshot.data ?? [];
                    var ingrediente = ingredientes.firstWhere((
                        ingrediente) => ingrediente['id'].toString() == idIngrediente,
                        orElse: () => null);
                    String nombreIngrediente = ingrediente != null
                        ? ingrediente['nombre'].toString()
                        : 'Nombre no disponible';
                    return Text(nombreIngrediente);
                  }
                },
              ),
            ),
            DataCell(
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          PedirIngrediente(
                            idIngrediente: idIngrediente,
                            cantidadNecesaria: cantidad,
                          ),
                    ),
                  ).then((_) {
                    _loadData();
                  });
                },
                child: const Text('Pedir'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}