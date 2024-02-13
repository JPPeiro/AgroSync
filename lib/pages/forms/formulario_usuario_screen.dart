import 'package:flutter/material.dart';
import '../../petittions_http.dart';

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
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                controller: _nombreController,
                label: 'Nombre',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextFormField(
                controller: _permisosController,
                label: 'Permisos',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los permisos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              _buildElevatedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              await actualizarUsuario(
                {
                  'id': widget.userId,
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
        },
        child: Text('Actualizar'),
      ),
    );
  }
}
