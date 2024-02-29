import 'package:agro_sync/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:agro_sync/components/my_button.dart';
import 'package:agro_sync/components/my_textfield.dart';
import 'package:colorful_background/colorful_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../petittions_http.dart';

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
          navigateToMainPage(context);
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

  void navigateToMainPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ColorfulBackground(
        duration: const Duration(milliseconds: 1000),
        backgroundColors: const [
          Color(0xFF121212),
          Color(0xFF121212),
        ],
        decoratorsList: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            right: MediaQuery.of(context).size.width / 2.5,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ) ,
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: 90,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            right: 90,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.45,
            right: 90,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  'AgroSync',
                  style: GoogleFonts.majorMonoDisplay(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 150),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Usuario',
                  obscureText: false,
                  suffixIconData: Icons.person,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  suffixIconData: Icons.lock,
                ),
                const SizedBox(height: 100),
                MyButton(
                    onTap: () => signInUser(context),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
