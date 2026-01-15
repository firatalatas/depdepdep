import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/api_service.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/repositories/earthquake_repository.dart';
import '../../models/earthquake_model.dart';

// Dependencies
final apiServiceProvider = Provider((ref) => ApiService());
final databaseHelperProvider = Provider((ref) => DatabaseHelper.instance);

final earthquakeRepositoryProvider = Provider((ref) {
  return EarthquakeRepository(
    ref.watch(apiServiceProvider),
    ref.watch(databaseHelperProvider),
  );
});

// State classes for the Earthquake Notifier
abstract class EarthquakeState {}
class EarthquakeInitial extends EarthquakeState {}
class EarthquakeLoading extends EarthquakeState {}
class EarthquakeLoaded extends EarthquakeState {
  final List<Earthquake> earthquakes;
  EarthquakeLoaded(this.earthquakes);
}
class EarthquakeError extends EarthquakeState {
  final String message;
  final List<Earthquake>? cachedData;
  EarthquakeError(this.message, {this.cachedData});
}

// Main Notifier
class EarthquakeNotifier extends StateNotifier<EarthquakeState> {
  final EarthquakeRepository _repository;

  EarthquakeNotifier(this._repository) : super(EarthquakeInitial()) {
    loadEarthquakes();
  }

  Future<void> loadEarthquakes() async {
    try {
      state = EarthquakeLoading();
      
      // 1. Load from Local DB
      final localData = await _repository.getLocalEarthquakes();
      if (localData.isNotEmpty) {
        state = EarthquakeLoaded(localData);
      }

      // 2. Fetch from Network
      final remoteData = await _repository.getRemoteEarthquakes();
      
      // 3. Save to DB and Update State
      if (remoteData.isNotEmpty) {
        await _repository.saveEarthquakes(remoteData);
        state = EarthquakeLoaded(remoteData);
      }
    } catch (e) {
      // If network fails, stick to local data if we have it
      if (state is EarthquakeLoaded) {
        // Already showing data, maybe show a snackbar in UI?
        // We can transition to Error state but keeping data
         state = EarthquakeError(e.toString(), cachedData: (state as EarthquakeLoaded).earthquakes);
      } else {
        // No data at all
        state = EarthquakeError(e.toString());
      }
    }
  }

  Future<void> refresh() async {
      await loadEarthquakes();
  }
}

final earthquakeProvider = StateNotifierProvider<EarthquakeNotifier, EarthquakeState>((ref) {
  return EarthquakeNotifier(ref.watch(earthquakeRepositoryProvider));
});

// Search Provider
final searchProvider = StateProvider<String>((ref) => '');

// Filtered List Provider
final filteredEarthquakeProvider = Provider<List<Earthquake>>((ref) {
  final earthquakeState = ref.watch(earthquakeProvider);
  // Helper function to normalize Turkish characters
  String normalize(String text) {
    var result = text.toLowerCase();
    result = result.replaceAll('ı', 'i');
    result = result.replaceAll('İ', 'i');
    result = result.replaceAll('ğ', 'g');
    result = result.replaceAll('ü', 'u');
    result = result.replaceAll('ş', 's');
    result = result.replaceAll('ö', 'o');
    result = result.replaceAll('ç', 'c');
    return result;
  }

  final searchQuery = normalize(ref.watch(searchProvider));

  List<Earthquake> allEarthquakes = [];
  if (earthquakeState is EarthquakeLoaded) {
    allEarthquakes = earthquakeState.earthquakes;
  } else if (earthquakeState is EarthquakeError && earthquakeState.cachedData != null) {
    allEarthquakes = earthquakeState.cachedData!;
  }

  if (searchQuery.isEmpty) {
    return allEarthquakes;
  }

  return allEarthquakes.where((eq) {
    final place = normalize(eq.location);
    return place.contains(searchQuery);
  }).toList();
});
