import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/earthquake_model.dart';
import '../../shared/theme/app_theme.dart';


class DetailPage extends StatelessWidget {
  final Earthquake earthquake;

  const DetailPage({super.key, required this.earthquake});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deprem Detayı")),
      body: Column(
        children: [
          // Map Placeholder Removed - TODO: Add Real Map Widget
          const SizedBox(
            height: 50,
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Big Magnitude Circle
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getMagColor(earthquake.magnitude),
                        width: 4,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      earthquake.magnitude.toString(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getMagColor(earthquake.magnitude),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMagStatus(earthquake.magnitude),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Info Cards
                  _buildInfoCard(Icons.location_on, "Konum", earthquake.location),
                  const SizedBox(height: 12),
                  _buildInfoCard(Icons.access_time, "Tarih & Saat", _formatDate(earthquake.date)),
                  const SizedBox(height: 12),
                  _buildInfoCard(Icons.layers, "Derinlik", "${earthquake.depth} km"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
           Icon(icon, color: AppTheme.primaryColor, size: 28),
           const SizedBox(width: 16),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
               const SizedBox(height: 4),
               Text(content, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
             ],
           )
        ],
      ),
    );
  }

  Color _getMagColor(double mag) {
    if (mag >= 5.0) return Colors.red;
    if (mag >= 3.0) return Colors.orange;
    return Colors.green;
  }

  String _getMagStatus(double mag) {
     if (mag >= 5.0) return "Yüksek Şiddet";
    if (mag >= 3.0) return "Orta Şiddet";
    return "Düşük Şiddet";
  }

  String _formatDate(String dateStr) {
      try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy HH:mm', 'tr_TR').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}
