import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';
import 'package:agro_sync/pages/pienso_details_screen.dart';
import 'main_page.dart';

class PiensosScreen extends StatelessWidget {
  const PiensosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Piensos'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade300, Colors.orange.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
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
            return ListWheelScrollView(
              itemExtent: 300, // Altura de cada elemento en la lista
              children: snapshot.data!.map<Widget>((pienso) {
                return CustomCard(pienso: pienso['nombre'].toString(), id: pienso['id']);
              }).toList(),
              // diameterRatio: 2,
            );
          }
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String pienso;
  final int id;

  const CustomCard({required this.pienso, required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PiensoDetailsScreen(piensoNombre: pienso, id: id,),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  'assets/img/Pienso1.png', // Ruta de la imagen estática
                  fit: BoxFit.contain,
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
