import 'package:agro_sync/pages/ingredientes_screen.dart';
import 'package:agro_sync/pages/proovedores_screen.dart';
import 'package:flutter/material.dart';
import 'package:agro_sync/pages/login_page.dart';
import 'package:agro_sync/pages/piensos_screen.dart';
import 'package:agro_sync/pages/usuarios_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('AgroSync'),
        leading: IconButton(
          icon: const Icon(Icons.power_settings_new_sharp),
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
            CustomCard(
              icon: Icons.supervised_user_circle,
              title: 'Usuarios',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsuariosScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.store,
              title: 'Proveedores',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProveedoresScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.feed_rounded,
              title: 'Piensos',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PiensosScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.shopping_cart,
              title: 'Pedidos Ingredientes',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PiensosScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.eco_sharp,
              title: 'Ingredientes',
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IngredientesScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final void Function()? onTap;

  const CustomCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: color,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        icon,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
