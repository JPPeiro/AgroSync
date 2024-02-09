import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';
import 'package:agro_sync/pages/login_page.dart';
import 'package:agro_sync/pages/pienso_details_screen.dart';

import 'main_page.dart';

class PiensosScreen extends StatelessWidget {

  const PiensosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        title: const Text('Piensos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerPiensos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron piensos.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var pienso = snapshot.data![index];
                return CustomCard(
                  pienso: pienso['nombre'].toString(),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String pienso;

  const CustomCard({required this.pienso, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PiensoDetailsScreen(piensoNombre: pienso),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.25),
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/img/Pienso1.png', // Ruta de la imagen estática
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  pienso,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}