import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../petittions_http.dart';

class PedirIngrediente extends StatefulWidget {
  final String idIngrediente;
  final String cantidadNecesaria;

  const PedirIngrediente({super.key,
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
    List<dynamic> ingredientesProveedoresData = await obtenerIngredienteProveedor();
    setState(() {
      ingredientesProveedores = ingredientesProveedoresData.where((proveedor) =>
      proveedor['idIngrediente'].toString() == widget.idIngrediente).toList();
    });

    // Obtener los idProveedor de los ingredientes filtrados
    List<int> idProveedores = ingredientesProveedores.map<int>((proveedor) => proveedor['idProveedor']).toList();
    // Obtener los datos de los proveedores con los idProveedor filtrados
    List<dynamic> proveedoresData = await obtenerProveedores();
    setState(() {
      // Filtrar los proveedores para obtener solo aquellos con idProveedor en idProveedores
      proveedores = proveedoresData.where((proveedor) => idProveedores.contains(proveedor['id'])).toList();
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
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: Text(
          'Pedir Ingredientes',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cantidad Necesaria: ${widget.cantidadNecesaria} kilos',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // Texto blanco
            ),
            const SizedBox(height: 20),
            _buildCantidadInput(),
            const SizedBox(height: 20),
            _buildProveedoresCards(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCantidadInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingrese la cantidad en kilos:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) {
            cantidadKilos = value;
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Cantidad en kilos',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          style: const TextStyle(color: Colors.white), // Texto blanco
        ),
      ],
    );
  }

  Widget _buildProveedoresCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientesProveedores.map((proveedor) {
        return Card(
          color: Colors.grey[800],
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proveedor: ${proveedor['nombre'] ?? 'Proveedor no disponible'}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Precio: ${proveedor['precio'].toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _calcularPrecioTotal(proveedor);
                      },
                      child: const Text('Calcular'),
                    ),
                    const SizedBox(width: 8), // Espacio entre los botones
                    ElevatedButton(
                      onPressed: () {
                        double cantidadIngresada = double.tryParse(cantidadKilos) ?? 0;
                        double cantidadNecesaria = double.tryParse(widget.cantidadNecesaria) ?? 0;
                        if (cantidadIngresada < cantidadNecesaria) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('La cantidad ingresada es inferior a la cantidad necesaria.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        int idIngrediente = int.tryParse(widget.idIngrediente) ?? 0;
                        aumentar(idIngrediente, cantidadKilos);
                        addPedido(proveedor, cantidadKilos);
                      },
                      child: const Text('Pedir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
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
            content: Text('El precio total es: \$${precioTotal.toStringAsFixed(2)}'),
            duration: const Duration(seconds: 2),
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

  Future<void> aumentar(int id, String cantidad) async {
    try {
      await aumentarCantidad(id,cantidad);
    } catch (e) {
      print('Error al crear el pedido: $e');
    }
  }
}
