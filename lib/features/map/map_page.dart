import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_providers.dart';
import '../../models/earthquake_model.dart';
import 'package:intl/intl.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earthquakes = ref.watch(filteredEarthquakeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deprem Haritası'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(39.0, 35.0), // Center of Turkey
          initialZoom: 6.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.deprem_uygulamasi',
          ),
          MarkerLayer(
            markers: earthquakes.map((e) {
              return Marker(
                point: LatLng(e.latitude, e.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    _showEarthquakeDetails(context, e);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getColorByMagnitude(e.magnitude),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        e.magnitude.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColorByMagnitude(double magnitude) {
    if (magnitude >= 5.0) return Colors.red;
    if (magnitude >= 4.0) return Colors.orange;
    if (magnitude >= 3.0) return Colors.amber;
    return Colors.green;
  }

  void _showEarthquakeDetails(BuildContext context, Earthquake earthquake) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                earthquake.location,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Büyüklük: ${earthquake.magnitude}'),
              Text('Derinlik: ${earthquake.depth} km'),
              Text('Tarih: ${earthquake.date}'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
