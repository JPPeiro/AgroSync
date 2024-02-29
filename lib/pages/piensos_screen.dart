import 'package:flutter/material.dart';
import 'package:agro_sync/petittions_http.dart';
import 'package:agro_sync/pages/pienso_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class PiensosScreen extends StatelessWidget {
  const PiensosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Piensos',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
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
            return VerticalCardPager(
              textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              initialPage: 0,
              titles: snapshot.data!.map<String>((pienso) => pienso['nombre'].toString()).toList(),
              images: snapshot.data!.map<Widget>((pienso) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  'assets/img/Pienso1.png',
                  fit: BoxFit.contain,
                ),
              )).toList(),
              onPageChanged: (page) {
              },
              onSelectedItem: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PiensoDetailsScreen(
                      piensoNombre: snapshot.data![index]['nombre'].toString(),
                      id: snapshot.data![index]['id'],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}