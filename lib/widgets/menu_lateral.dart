import 'package:flutter/material.dart';

class MenuLateral extends StatelessWidget {
  final VoidCallback limparDestino;

  const MenuLateral({
    super.key,
    required this.limparDestino,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF7F3EA),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              color: const Color.fromARGB(255, 110, 72, 121),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.map,
                    color: Colors.white,
                    size: 45,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Flutter Maps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mapas e coordenadas',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 72, 74, 121),
              ),
              title: const Text(
                'Mapa',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color.fromARGB(255, 110, 72, 121),
              ),
              title: const Text(
                'Limpar ponto',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              onTap: () {
                limparDestino();
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Color(0xFF795548),
              ),
              title: const Text(
                'Sobre',
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Flutter Maps',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.map,
                    size: 40,
                  ),
                  children: const [
                    Text(
                      'Aplicativo desenvolvido para a Aula 05 - Mapas.',
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}