import 'package:flutter/material.dart';
import 'package:agro_sync/components/my_button.dart';
import 'package:agro_sync/components/my_textfield.dart';

import '../petitions_http.dart';
import 'SignIn.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) async {
    // Lógica de autenticación aquí
    try {
      // Realizar la llamada a la API para obtener la lista de usuarios
      List<dynamic> usuarios = await obtenerUsuarios();
      print(usuarios);
      // Obtener el usuario con el nombre de usuario proporcionado
      dynamic usuario = usuarios.firstWhere(
            (user) => user['nombre'] == usernameController.text,
        orElse: () => null,
      );
      print(usuario['contrasena']);
      print(usuario['nombre']);
      // Verificar si el usuario existe y la contraseña es correcta
      if (usuario != null && usuario['contrasena'] == passwordController.text) {
        // Después de autenticar con éxito, redirige a la página de inicio con el nombre de usuario
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(username: usernameController.text),
          ),
        );
      } else {
        // Manejar caso de autenticación fallida

        print('Autenticación fallida');
      }
    } catch (e) {
      // Manejar errores de red u otros errores
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: () => signUserIn(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
