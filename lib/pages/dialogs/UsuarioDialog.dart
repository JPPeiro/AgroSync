import 'package:flutter/material.dart';
import '../../petittions_http.dart';

class UsuarioDialog extends StatefulWidget {
  final int tipo;
  final int? id;

  const UsuarioDialog({super.key, required this.tipo, this.id});

  @override
  _CrearUsuarioDialogState createState() => _CrearUsuarioDialogState();
}

class _CrearUsuarioDialogState extends State<UsuarioDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _permisosController = TextEditingController();
  bool _formularioValido = false;

  @override
  void initState() {
    super.initState();
    if (widget.tipo == 2) {
      _obtenerUsuarios();
    }
  }

  Future<void> _obtenerUsuarios() async {
    List<dynamic> usuarios = await obtenerUsuarios();

    Map<String, dynamic>? usuarioEncontrado = usuarios.firstWhere(
          (usuario) => usuario['id'] == widget.id,
      orElse: () => null,
    );

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
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Permisos',
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
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: _formularioValido
              ? () {
            if (widget.tipo == 1) {
              _crearUsuario(context);
            } else if (widget.tipo == 2) {
              _editarUsuario(context);
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

  Future<void> _crearUsuario(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await crearUsuario({
          'nombre': _nombreController.text,
          'password': _passwordController.text,
          'permisos': _permisosController.text,
        });
        List<dynamic> listaUsuarios = await obtenerUsuarios();
        Navigator.pop(context, listaUsuarios);
      } catch (e) {
        print('Error al crear el usuario: $e');
      }
    }
  }

  Future<void> _editarUsuario(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print(widget.id);
      try {
        await actualizarUsuario({
          'id': widget.id,
          'nombre': _nombreController.text,
          'password': _passwordController.text,
          'permisos': _permisosController.text,
        });
        List<dynamic> listaUsuarios = await obtenerUsuarios();
        Navigator.pop(context, listaUsuarios);
      } catch (e) {
        print('Error al actualizar el usuario: $e');
      }
    }
  }
}
