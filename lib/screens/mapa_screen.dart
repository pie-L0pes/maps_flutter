import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../widgets/coordenadas_card.dart';
import '../widgets/menu_lateral.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  static const LatLng origem = LatLng(
    -22.7130000,
    -46.8180000,
  );

  LatLng? destino;

  List<LatLng> pontosRota = [];

  final MapController _mapController = MapController();

  bool carregandoRota = false;

  Future<void> selecionarDestino(LatLng ponto) async {
    setState(() {
      destino = ponto;
      pontosRota = [];
      carregandoRota = true;
    });

    await calcularRota(ponto);
  }

  Future<void> calcularRota(LatLng destino) async {
    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${origem.longitude},${origem.latitude};'
        '${destino.longitude},${destino.latitude}'
        '?overview=full&geometries=geojson',
      );

      final resposta = await http.get(url);

      if (resposta.statusCode != 200) {
        throw Exception('Erro ao buscar a rota.');
      }

      final dados = jsonDecode(resposta.body);

      if (dados['routes'] == null || dados['routes'].isEmpty) {
        throw Exception('Nenhuma rota encontrada.');
      }

      final coordenadas =
          dados['routes'][0]['geometry']['coordinates'] as List;

      final rota = coordenadas.map<LatLng>((coordenada) {
        return LatLng(
          (coordenada[1] as num).toDouble(),
          (coordenada[0] as num).toDouble(),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        pontosRota = rota;
        carregandoRota = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregandoRota = false;
        pontosRota = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível calcular a rota.'),
        ),
      );
    }
  }

  void limparDestino() {
    setState(() {
      destino = null;
      pontosRota = [];
      carregandoRota = false;
    });

    _mapController.move(origem, 17);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(
        limparDestino: limparDestino,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 132, 83, 159),
        foregroundColor: Colors.white,
        title: const Text(
          'Map traçar Rota',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: origem,
              initialZoom: 17,

              onTap: (tapPosition, latLng) {
                selecionarDestino(latLng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.flutter_maps_nativo',
              ),

              // LINHA DA ROTA
              if (pontosRota.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: pontosRota,
                      strokeWidth: 6,
                      color: const Color.fromARGB(255, 243, 33, 219),
                    ),
                  ],
                ),

              // MARCADORES
              MarkerLayer(
                markers: [
                  Marker(
                    point: origem,
                    width: 55,
                    height: 55,
                    child: const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 243, 33, 240),
                      size: 50,
                    ),
                  ),

                  if (destino != null)
                    Marker(
                      point: destino!,
                      width: 55,
                      height: 55,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // COORDENADAS
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Column(
                children: [
                  Text(
                    'Origem: @${origem.latitude}, ${origem.longitude}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    destino == null
                        ? 'Destino: toque em um ponto do mapa'
                        : 'Destino: @${destino!.latitude}, '
                            '${destino!.longitude}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CARREGANDO
          if (carregandoRota)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(width: 12),
                      Text('Calculando rota...'),
                    ],
                  ),
                ),
              ),
            ),

          // CARD DAS COORDENADAS
          if (destino != null && !carregandoRota)
            Positioned(
              left: 15,
              right: 15,
              bottom: 15,
              child: CoordenadasCard(
                origem: origem,
                destino: destino!,
                limparDestino: limparDestino,
              ),
            ),

          // INSTRUÇÃO INICIAL
          if (destino == null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.touch_app,
                        color: Color.fromARGB(255, 208, 33, 243),
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Toque em um ponto do mapa para marcar o destino.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}