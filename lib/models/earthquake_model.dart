class Earthquake {
  final String id;
  final double magnitude;
  final double depth;
  final String date; // ISOString or formatted string
  final String location;
  final double latitude;
  final double longitude;

  final String? source;
  final int? createdAt;

  Earthquake({
    required this.id,
    required this.magnitude,
    required this.depth,
    required this.date,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.source,
    this.createdAt,
  });

  // Factory to create from Kandilli API JSON
  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final geojson = json['geojson'];
    final coordinates = (geojson != null && geojson['coordinates'] is List)
        ? geojson['coordinates'] as List
        : [0.0, 0.0];

    return Earthquake(
      id: json['earthquake_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      magnitude: double.tryParse(json['mag']?.toString() ?? '0') ?? 0.0,
      depth: double.tryParse(json['depth']?.toString() ?? '0') ?? 0.0,
      date: json['date_time']?.toString() ?? '',
      location: _normalizeLocation(json['title']?.toString() ?? 'Bilinmeyen Konum'),
      latitude: double.tryParse(coordinates[1].toString()) ?? 0.0, // GeoJSON is [lon, lat]
      longitude: double.tryParse(coordinates[0].toString()) ?? 0.0,
      source: json['provider']?.toString() ?? 'Kandilli', 
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Factory to create from SQLite Map
  factory Earthquake.fromMap(Map<String, dynamic> map) {
    return Earthquake(
      id: map['id'] as String,
      magnitude: map['magnitude'] as double,
      depth: map['depth'] as double,
      date: map['time'] as String, // Stored as String for simplicity or could be epoch
      location: map['place'] as String,
      latitude: map['lat'] as double,
      longitude: map['lon'] as double,
      source: map['source'] as String?,
      createdAt: map['created_at'] as int?,
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'magnitude': magnitude,
      'depth': depth,
      'time': date,
      'place': location,
      'lat': latitude,
      'lon': longitude,
      'source': source,
      'created_at': createdAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  // Helper to fix encoding or formatting issues if any
  static String _normalizeLocation(String loc) {
    // Basic trimming, specific fixes could go here
    return loc.trim();
  }
}
