import 'package:flutter/material.dart';
import '../petittions_http.dart';

class PedirIngrediente extends StatefulWidget {
  final int idIngrediente;
  final double cantidadNecesaria;

  const PedirIngrediente({
    required this.idIngrediente,
    required this.cantidadNecesaria,
  });

  @override
  _PedirIngredienteState createState() => _PedirIngredienteState();
}

class _PedirIngredienteState extends State<PedirIngrediente> {
  String cantidadKilos = '';
  List<dynamic> ingredientesProveedores = [];
  List<dynamic> proveedores = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  Future<void> _fetchData() async {
    // Obtener los datos de los proveedores que venden el ingrediente específico
    List<
        dynamic> ingredientesProveedoresData = await obtenerIngredienteProveedor();
    setState(() {
      // Filtrar los datos para obtener solo aquellos cuyo idIngrediente coincida
      ingredientesProveedores = ingredientesProveedoresData.where((proveedor) =>
      proveedor['idIngrediente'] == widget.idIngrediente)
          .toList();
    });

    // Obtener los idProveedor de los ingredientes filtrados
    List<int> idProveedores = ingredientesProveedores.map<int>((
        proveedor) => proveedor['idProveedor']).toList();

    // Obtener los datos de los proveedores con los idProveedor filtrados
    List<dynamic> proveedoresData = await obtenerProveedores();
    setState(() {
      // Filtrar los proveedores para obtener solo aquellos con idProveedor en idProveedores
      proveedores = proveedoresData.where((proveedor) =>
          idProveedores.contains(proveedor['id'])).toList();
    });

    // Obtener y asignar el nombre del proveedor a cada entrada en ingredientesProveedores
    for (var proveedor in ingredientesProveedores) {
      var nombreProveedor = proveedores.firstWhere((p) =>
      p['id'] == proveedor['idProveedor'], orElse: () => null);
      if (nombreProveedor != null) {
        proveedor['nombre'] = nombreProveedor['nombre'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fabricar Pienso'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cantidad Necesaria: ${widget.cantidadNecesaria} kilos',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                cantidadKilos = value;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad en Kilos',
                hintText: 'Ingrese la cantidad en kilos',
              ),
            ),
            const SizedBox(height: 20),
            _buildProveedoresTable(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProveedoresTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Proveedor')),
        DataColumn(label: Text('Precio')),
        DataColumn(label: Text('Acción')),
      ],
      rows: ingredientesProveedores.map((proveedor) {
        return DataRow(cells: [
          DataCell(Text(proveedor['nombre'] ?? 'Proveedor no disponible')),
          DataCell(Text(proveedor['precio'].toString())),
          DataCell(Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _calcularPrecioTotal(proveedor);
                },
                child: const Text('Calcular'),
              ),
              SizedBox(width: 8), // Espacio entre los botones
              ElevatedButton(
                onPressed: () {
                  addPedido(proveedor, cantidadKilos);
                },
                child: const Text('Pedir'),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  void _calcularPrecioTotal(Map<String, dynamic> proveedor) {
    if (cantidadKilos.isNotEmpty) {
      double cantidadFabricada = double.tryParse(cantidadKilos) ?? 0;
      if (cantidadFabricada > 0) {
        double precioPorKilo = proveedor['precio'] ?? 0;
        double precioTotal = cantidadFabricada * precioPorKilo;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'El precio total es: \$${precioTotal.toStringAsFixed(2)}'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, ingrese una cantidad válida.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese la cantidad en kilos.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  Future<void> addPedido(Map<String, dynamic> proveedor, String cantidadKilos) async {
    double cantidad = double.tryParse(cantidadKilos) ?? 0;
    double precioPorKilo = proveedor['precio'] ?? 0;
    double costoTotal = cantidad * precioPorKilo;

    try {
      await crearPedido(
        {
          'proveedorId': proveedor['idProveedor'],
          'ingredienteId': proveedor['idIngrediente'],
          'cantidad': cantidad,
          'coste': costoTotal,
        }
      );
      print('Pedido creado correctamente');
      Navigator.pop(context);
    } catch (e) {
      print('Error al crear el pedido: $e');
    }
  }
}