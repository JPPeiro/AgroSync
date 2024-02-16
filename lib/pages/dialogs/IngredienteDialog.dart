import 'package:flutter/material.dart';

import '../../petittions_http.dart';

class IngredienteDialog extends StatefulWidget {
  final int tipo; // Parámetro para indicar si se está creando (1) o editando (2) un ingrediente
  final int? id;

  IngredienteDialog({required this.tipo, this.id});

  @override
  _CrearIngredienteDialogState createState() => _CrearIngredienteDialogState();
}

class _CrearIngredienteDialogState extends State<IngredienteDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _inventarioController = TextEditingController();
  bool _formularioValido = false;

  @override
  void initState() {
    super.initState();
    if (widget.tipo == 2) {
      _obtenerIngredientes();
    }
  }

  Future<void> _obtenerIngredientes() async {
    List<dynamic> ingredientes = await obtenerIngredientes();

    Map<String, dynamic>? ingredienteEncontrado = ingredientes.firstWhere((ingrediente) => ingrediente['id'] == widget.id, orElse: () => null);

    if (ingredienteEncontrado != null) {
      _nombreController.text = ingredienteEncontrado['nombre'];
      _inventarioController.text = ingredienteEncontrado['cantidad'].toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    String titulo = widget.tipo == 1 ? 'Añadir Ingrediente' : 'Editar Ingrediente';
    String botonTexto = widget.tipo == 1 ? 'Añadir' : 'Editar';

    return AlertDialog(
      title: Text(titulo),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onChanged: (_) => _validarFormulario(),
            ),
            TextFormField(
              controller: _inventarioController,
              decoration: InputDecoration(labelText: 'Inventario'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onChanged: (_) => _validarFormulario(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo al presionar Cancelar
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _formularioValido
              ? () {
            if (widget.tipo == 1) {
              _crearIngrediente(context);
            } else if (widget.tipo == 2) {
              _editarIngrediente(context);
            }
          }
              : null,
          child: Text(botonTexto),
        ),
      ],
    );
  }

  // Método para validar el formulario
  void _validarFormulario() {
    setState(() {
      _formularioValido = _formKey.currentState!.validate();
    });
  }

  Future<void> _crearIngrediente(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await crearIngrediente(
          {
            'nombre': _nombreController.text,
            'cantidad': _inventarioController.text,
          },
        );
        List<dynamic> listaIngredientes = await obtenerIngredientes();
        Navigator.pop(context, listaIngredientes);
      } catch (e) {
        print('Error al crear el ingrediente: $e');
      }
    }
  }

  Future<void> _editarIngrediente(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print(widget.id);
      try {
        await actualizarIngrediente(
          {
            'id': widget.id,
            'nombre': _nombreController.text,
            'cantidad': _inventarioController.text,
          },
        );
        List<dynamic> listaIngredientes = await obtenerIngredientes();
        Navigator.pop(context, listaIngredientes);
      } catch (e) {
        print('Error al actualizar el ingrediente: $e');
      }
    }
  }
}