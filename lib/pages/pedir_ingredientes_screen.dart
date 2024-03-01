import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../petittions_http.dart';

class PedirIngrediente extends StatefulWidget {
  final String idIngrediente;
  final double cantidadNecesaria;

  const PedirIngrediente({
    super.key,
    required this.idIngrediente,
    required this.cantidadNecesaria,
  });

  @override
  _PedirIngredienteState createState() => _PedirIngredienteState();
}

class _PedirIngredienteState extends State<PedirIngrediente> {
  String cantidadKilos = '';
  String unidadSeleccionada = 'kilos';
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

    List<int> idProveedores = ingredientesProveedores.map<int>((proveedor) => proveedor['idProveedor']).toList();
    List<dynamic> proveedoresData = await obtenerProveedores();
    setState(() {
      proveedores = proveedoresData.where((proveedor) => idProveedores.contains(proveedor['id'])).toList();
    });

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Pedir Ingredientes',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cantidad Necesaria: ${widget.cantidadNecesaria} kilos',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          'Ingrese la cantidad:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                onChanged: (value) {
                  cantidadKilos = value;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Cantidad',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.grey[900],
                ),
                child: DropdownButtonFormField<String>(
                  value: unidadSeleccionada,
                  onChanged: (value) {
                    setState(() {
                      unidadSeleccionada = value!;
                    });
                  },
                  items: ['kilos', 'gramos'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _pedirIngrediente(proveedor);
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
      double cantidadFabricada = _convertirAKilos(double.tryParse(cantidadKilos) ?? 0);
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
          content: Text('Por favor, ingrese la cantidad.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  double _convertirAKilos(double cantidad) {
    if (unidadSeleccionada == 'gramos') {
      return cantidad / 1000; // Convertir gramos a kilos
    }
    return cantidad; // No es necesario convertir si está en kilos
  }

  void _pedirIngrediente(Map<String, dynamic> proveedor) {
    if (cantidadKilos.isNotEmpty) {
      double cantidadPedida = _convertirAKilos(double.tryParse(cantidadKilos) ?? 0);
      double cantidadNecesaria = widget.cantidadNecesaria ?? 0;
      if (cantidadPedida < cantidadNecesaria) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La cantidad ingresada es inferior a la cantidad necesaria.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      aumentar(proveedor["idIngrediente"], cantidadPedida.toString());
      addPedido(proveedor, cantidadPedida.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese la cantidad.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> aumentar(int id, String cantidad) async {
    try {
      await aumentarCantidad(id,cantidad);
    } catch (e) {
      print('Error al crear el pedido: $e');
    }
  }

  Future<void> addPedido(Map<String, dynamic> proveedor, String cantidadKilos) async {
    print(cantidadKilos);
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
        },
      );
      print('Pedido creado correctamente');
      Navigator.pop(context);
    } catch (e) {
      print('Error al crear el pedido: $e');
    }
  }
}
