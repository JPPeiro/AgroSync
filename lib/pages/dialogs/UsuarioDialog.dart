import 'package:flutter/material.dart';

import '../../petittions_http.dart';

class UsuarioDialog extends StatefulWidget {
  final int tipo; // Parámetro para indicar si se está creando (1) o editando (2) un usuario
  final int? id;

  UsuarioDialog({required this.tipo, this.id});

  @override
  _CrearUsuarioDialogState createState() => _CrearUsuarioDialogState();
}

class _CrearUsuarioDialogState extends State<UsuarioDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _permisosController = TextEditingController();
  bool _formularioValido = false; // Estado para controlar si el formulario es válido

  @override
  void initState() {
    super.initState();
    if (widget.tipo == 2) {
      _obtenerUsuarios();
    }
  }


  Future<void> _obtenerUsuarios() async {
    List<dynamic> usuarios = await obtenerUsuarios();

    Map<String, dynamic>? usuarioEncontrado = usuarios.firstWhere((usuario) => usuario['id'] == widget.id, orElse: () => null);

    if (usuarioEncontrado != null) {
      _nombreController.text = usuarioEncontrado['nombre'];
      _passwordController.text = usuarioEncontrado['contrasena'].toString();
      _permisosController.text = usuarioEncontrado['permisos'].toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    String titulo = widget.tipo == 1 ? 'Crear Usuario' : 'Editar Usuario';
    String botonTexto = widget.tipo == 1 ? 'Crear' : 'Editar';

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
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onChanged: (_) => _validarFormulario(),
            ),
            TextFormField(
              controller: _permisosController,
              decoration: InputDecoration(labelText: 'Permisos'),
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
          onPressed: _formularioValido ? () {
            if (widget.tipo == 1) {
              _crearUsuario(context);
            } else if (widget.tipo == 2) {
              _editarUsuario(context);
            }
          } : null,
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

  // Método para crear el usuario
  Future<void> _crearUsuario(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await crearUsuario(
        {
          'nombre': _nombreController.text,
          'password': _passwordController.text,
          'permisos': _permisosController.text,
        },
        );
        List<dynamic> listaUsuarios = await obtenerUsuarios();
        Navigator.pop(context, listaUsuarios);
      } catch (e) {
        print('Error al crear el usuario: $e');
      }
    }
  }
  // Método para editar el usuario
  Future<void> _editarUsuario(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print(widget.id);
      try {
        await actualizarUsuario(
          {
            'id': widget.id,
            'nombre': _nombreController.text,
            'password': _passwordController.text,
            'permisos': _permisosController.text,
          },
        );
        List<dynamic> listaUsuarios = await obtenerUsuarios();
        Navigator.pop(context, listaUsuarios);
      } catch (e) {
        print('Error al actualizar el usuario: $e');
      }
    }
  }
}