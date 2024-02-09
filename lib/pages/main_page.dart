import 'package:agro_sync/pages/login_page.dart';
import 'package:agro_sync/pages/piensos_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piensos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            CustomCircleAvatar(
              nombre: "Usuarios",
              color: Colors.blue, // Cambia el color según sea necesario
            ),
            const SizedBox(height: 20),
            CustomCircleAvatar(
              nombre: "Proveedores",
              color: Colors.green, // Cambia el color según sea necesario
            ),
            const SizedBox(height: 20),
            CustomCircleAvatar(
              nombre: "Piensos",
              color: Colors.orange, // Cambia el color según sea necesario
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  final String nombre;
  final Color color;

  const CustomCircleAvatar({
    Key? key,
    required this.nombre,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PiensosScreen(),
          ),
        );
      },
      child: CircleAvatar(
        radius: 110,
        backgroundColor: color,
        child: Text(
          nombre,
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
