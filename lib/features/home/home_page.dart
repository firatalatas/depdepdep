import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_theme.dart';
import 'home_providers.dart';
import 'widgets/earthquake_list.dart';
import '../map/map_page.dart'; // Import MapPage
import '../about/about_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final earthquakeState = ref.watch(earthquakeProvider);
    final filteredEarthquakes = ref.watch(filteredEarthquakeProvider);
    final searchController = TextEditingController(text: ref.watch(searchProvider));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.monitor_heart, color: AppTheme.primaryColor),
             SizedBox(width: 8),
            Text("Deprem Takip"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const MapPage()),
               );
             },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Şehir veya ilçe ara',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                 _onSearchChanged(value);
              },
            ),
          ),

          // List Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Son Depremler",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                 // Refresh Button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(earthquakeProvider.notifier).refresh();
                  },
                ),
              ],
            ),
          ),

          // List Body
          Expanded(
            child: Builder(
              builder: (context) {
                if (earthquakeState is EarthquakeLoading && filteredEarthquakes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (earthquakeState is EarthquakeError) {
                   if (filteredEarthquakes.isEmpty) {
                     return Center(child: Text("Hata: ${earthquakeState.message}"));
                   }
                }

                return EarthquakeList(earthquakes: filteredEarthquakes);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Debounce logic
  DateTime? _lastInputTime;
  
  void _onSearchChanged(String query) {
    final now = DateTime.now();
    _lastInputTime = now;
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_lastInputTime == now) {
        ref.read(searchProvider.notifier).state = query;
      }
    });
  }
}
