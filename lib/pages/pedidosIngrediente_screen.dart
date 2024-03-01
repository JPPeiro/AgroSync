import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../petittions_http.dart';

class PedidosIngredientes extends StatefulWidget {
  const PedidosIngredientes({super.key});

  @override
  _PedidosIngredientesState createState() => _PedidosIngredientesState();
}

class _PedidosIngredientesState extends State<PedidosIngredientes> {
  late List<dynamic> pedidos = [];
  late List<dynamic> ingredientes;
  late List<dynamic> proveedores;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      pedidos = await obtenerPedidos();
      ingredientes = await obtenerIngredientes();
      proveedores = await obtenerProveedores();
      setState(() {});
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  String obtenerNombreProveedor(String proveedorId) {
    var proveedor = proveedores.firstWhere(
          (proveedor) => proveedor['id'].toString() == proveedorId,
      orElse: () => {},
    );
    return proveedor['nombre'] ?? 'Desconocido';
  }

  String obtenerNombreIngrediente(String ingredienteId) {
    var ingrediente = ingredientes.firstWhere(
          (ingrediente) => ingrediente['id'].toString() == ingredienteId,
      orElse: () => {},
    );
    return ingrediente['nombre'] ?? 'Desconocido';
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

  Widget _buildDataRow(String proveedorId, String ingredienteId, String cantidad, String coste) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Editar',
            backgroundColor: Colors.blue,
            icon: Icons.edit,
            onPressed: (context) => print('Editar'),
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
              _buildDataCell(obtenerNombreProveedor(proveedorId)),
              _buildDataCell(obtenerNombreIngrediente(ingredienteId)),
              _buildDataCell(cantidad),
              _buildDataCell(coste),
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
          'Pedidos Ingredientes',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: pedidos == null
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
          ? const Center(child: Text('No se encontraron pedidos.'))
          : ListView(
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 8),
          ...pedidos.map((pedido) {
            return _buildDataRow(
              pedido['proveedorId'].toString(),
              pedido['ingredienteId'].toString(),
              pedido['cantidad'].toString(),
              pedido['coste'].toString(),
            );
          }),
        ],
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
      color: Colors.red,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeaderCell('Proveedor'),
            _buildHeaderCell('Ingrediente'),
            _buildHeaderCell('Cantidad'),
            _buildHeaderCell('Coste'),
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
