import 'package:agro_sync/pages/pedidosIngrediente_screen.dart';
import 'package:agro_sync/pages/piensos_screen.dart';
import 'package:agro_sync/pages/proovedores_screen.dart';
import 'package:agro_sync/pages/usuarios_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_sync/pages/login_page.dart';

import 'ingredientes_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'AgroSync',
          style: GoogleFonts.majorMonoDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.power_settings_new_sharp),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Establecer el color de los iconos de la AppBar
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
              color: Colors.indigo,
              onTap: () {
                _navigateToPage(context, const UsuariosScreen());
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.store,
              title: 'Proveedores',
              color: Colors.teal,
              onTap: () {
                _navigateToPage(context, const ProveedoresScreen());
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.feed_rounded,
              title: 'Piensos',
              color: Colors.amber,
              onTap: () {
                _navigateToPage(context, const PiensosScreen());
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.shopping_cart,
              title: 'Pedidos Ingredientes',
              color: Colors.red,
              onTap: () {
                _navigateToPage(context, const PedidosIngredientes());
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              icon: Icons.eco_sharp,
              title: 'Ingredientes',
              color: Colors.deepPurple,
              onTap: () {
                _navigateToPage(context, const IngredientesScreen());
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

void _navigateToPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
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
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

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
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
