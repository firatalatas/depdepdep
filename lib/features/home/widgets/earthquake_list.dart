import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/earthquake_model.dart';
import '../../detail/detail_page.dart';

class EarthquakeList extends StatelessWidget {
  final List<Earthquake> earthquakes;

  const EarthquakeList({super.key, required this.earthquakes});

  @override
  Widget build(BuildContext context) {
    if (earthquakes.isEmpty) {
      return const Center(
        child: Text("Bu aramada deprem bulunamadı."),
      ); // Requirement: "Boş sonuç: Bu aramada deprem bulunamadı."
    }

    return ListView.builder(
      itemCount: earthquakes.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final eq = earthquakes[index];
        return _buildCard(context, eq);
      },
    );
  }

  Widget _buildCard(BuildContext context, Earthquake eq) {
    // Color logic
    Color magColor;
    if (eq.magnitude >= 5.0) {
      magColor = Colors.red;
    } else if (eq.magnitude >= 3.0) {
      magColor = Colors.orange;
    } else {
      magColor = Colors.green; // Or maybe a lighter orange/yellow
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
             Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(earthquake: eq),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Magnitude Circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: magColor, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  eq.magnitude.toString(),
                  style: TextStyle(
                    color: magColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eq.location,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${_formatDate(eq.date)} • Derinlik: ${eq.depth} km",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Chevron
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      // Assuming AFAD returns ISO, or we just display what we have if specific format
      // Example: 2023-01-01T12:00:00
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM HH:mm', 'tr_TR').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}
