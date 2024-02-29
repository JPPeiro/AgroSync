import 'package:flutter/material.dart';

import '../../petittions_http.dart';

class IngredienteDialog extends StatefulWidget {
  final int tipo;
  final int? id;

  const IngredienteDialog({super.key, required this.tipo, this.id});

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
      backgroundColor: Colors.grey[900],
      title: Text(
        titulo,
        style: const TextStyle(color: Colors.white),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Inventario',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
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
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar',
            style: TextStyle(color: Colors.white),
          ),
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