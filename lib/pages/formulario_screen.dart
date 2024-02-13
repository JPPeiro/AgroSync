import 'package:flutter/material.dart';
import '../petittions_http.dart';

class FormularioScreen extends StatefulWidget {
  final int userId;

  FormularioScreen({required this.userId});

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _permisosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _permisosController,
                decoration: InputDecoration(labelText: 'Permisos'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los permisos';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Si los campos del formulario son válidos
                      try {
                        // Llama al método de petición HTTP para actualizar el usuario
                        actualizarUsuario(
                          {
                            'id': widget.userId,
                            'nombre': _nombreController.text,
                            'password': _passwordController.text,
                            'permisos': _permisosController.text,
                          },
                        );
                        List<dynamic> listaUsuarios = await obtenerUsuarios();
                        print('Lista de usuarios: $listaUsuarios');

                        // Navega de regreso a la pantalla de los piensos
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error al actualizar el usuario: $e');
                        // Maneja el error aquí si es necesario
                      }
                    }
                  },
                  child: Text('Actualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

