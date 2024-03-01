import 'package:agro_sync/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:agro_sync/components/my_button.dart';
import 'package:agro_sync/components/my_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metaballs/metaballs.dart';

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
      body: Stack(
        children: [
          Metaballs(
            color: const Color.fromARGB(255, 66, 133, 244),
            effect: MetaballsEffect.follow(
              growthFactor: 1,
              smoothing: 1,
              radius: 0.5,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 255, 0),
                Color.fromARGB(255, 128, 0, 128),
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            metaballs: 40,
            animationDuration: const Duration(milliseconds: 200),
            speedMultiplier: 1,
            bounceStiffness: 3,
            minBallRadius: 15,
            maxBallRadius: 40,
            glowRadius: 0.7,
            glowIntensity: 0.6,
            child: const SizedBox.expand(),
          ),

          SingleChildScrollView(
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
        ],
      ),
    );
  }
}