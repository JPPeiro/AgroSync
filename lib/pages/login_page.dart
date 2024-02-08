import 'package:flutter/material.dart';
import 'package:agro_sync/components/my_button.dart';
import 'package:agro_sync/components/my_textfield.dart';

import '../petittions_http.dart';
import 'piensos_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser(BuildContext context) async {
    try {
      final usuarios = await obtenerUsuarios();
      final usuario = usuarios.firstWhere(
            (user) => user['nombre'] == usernameController.text,
        orElse: () => null,
      );

      if (usuario != null) {
        if (usuario['password'] == passwordController.text) {
          navigateToPiensosScreen(context);
        } else {
          print('Contraseña incorrecta');
        }
      } else {
        print('Nombre de usuario no encontrado');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToPiensosScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PiensosScreen(username: usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  'assets/img/logo.png',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 30),
                Text(
                  '¡Bienvenido de vuelta!',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Usuario',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                SizedBox(height: 30),
                MyButton(
                    onTap: () => signInUser(context),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
