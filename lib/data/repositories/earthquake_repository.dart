import '../../models/earthquake_model.dart';
import '../datasources/api_service.dart';
import '../datasources/database_helper.dart';

class EarthquakeRepository {
  final ApiService _apiService;
  final DatabaseHelper _dbHelper;

  EarthquakeRepository(this._apiService, this._dbHelper);

  Future<List<Earthquake>> getLocalEarthquakes() {
    return _dbHelper.getEarthquakes();
  }

  Future<List<Earthquake>> getRemoteEarthquakes() async {
    return await _apiService.fetchEarthquakes();
  }

  Future<void> saveEarthquakes(List<Earthquake> earthquakes) async {
    await _dbHelper.insertEarthquakes(earthquakes);
  }
}
