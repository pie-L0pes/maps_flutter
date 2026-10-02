import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CoordenadasCard extends StatelessWidget {
  final LatLng origem;
  final LatLng destino;
  final VoidCallback limparDestino;

  const CoordenadasCard({
    super.key,
    required this.origem,
    required this.destino,
    required this.limparDestino,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.route,
                  color: Color.fromARGB(255, 243, 33, 240),
                ),
                SizedBox(width: 8),
                Text(
                  'Linha entre os pontos',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              'Origem: ${origem.latitude.toStringAsFixed(6)}, '
              '${origem.longitude.toStringAsFixed(6)}',
            ),

            const SizedBox(height: 5),

            Text(
              'Destino: ${destino.latitude.toStringAsFixed(6)}, '
              '${destino.longitude.toStringAsFixed(6)}',
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: limparDestino,
                icon: const Icon(Icons.clear),
                label: const Text('Limpar ponto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}