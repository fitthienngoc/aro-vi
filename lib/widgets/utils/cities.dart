// lib/cities.dart
//
// Cách dùng nhanh:
// final cities = await loadCities(); // đọc từ assets/vn_cities.json
// final c = nearestCity(tapLatLng, cities, zoom: mapController.camera.zoom);
// if (c != null) { /* action với c */ }

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class City {
  final String name;
  final LatLng latLng;

  /// Mã/tên rút gọn (tùy chọn) – ví dụ "VN-HN" để gọi API/điều hướng.
  final String? code;

  const City({required this.name, required this.latLng, this.code});

  factory City.fromMap(Map<String, dynamic> m) {
    // Hỗ trợ cả 'lon' hoặc 'lng'
    final lat = (m['lat'] as num).toDouble();
    final lng = (m['lng'] ?? m['lon']) as num;
    return City(
      name: m['name'] as String,
      latLng: LatLng(lat, (lng).toDouble()),
      code: (m['code'] as String?)?.trim().isEmpty == true
          ? null
          : m['code'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'lat': latLng.latitude,
    'lng': latLng.longitude,
    if (code != null) 'code': code,
  };
}

/// Đọc danh sách thành phố từ asset JSON.
/// Mặc định: assets/vn_cities.json
Future<List<City>> loadCities({
  String assetPath = 'assets/vn_cities.json',
}) async {
  final raw = await rootBundle.loadString(assetPath);
  final data = json.decode(raw);
  if (data is List) {
    return data.map((e) => City.fromMap(Map<String, dynamic>.from(e))).toList();
  }
  // Trường hợp file dùng dạng { "cities": [ ... ] }
  if (data is Map && data['cities'] is List) {
    final arr = (data['cities'] as List).cast<dynamic>();
    return arr.map((e) => City.fromMap(Map<String, dynamic>.from(e))).toList();
  }
  throw const FormatException(
    'vn_cities.json không đúng định dạng (List hoặc { "cities": [...] }).',
  );
}

/// Khoảng cách Haversine (mét) giữa 2 điểm LatLng.
double distanceMeters(LatLng a, LatLng b) {
  const R = 6371000.0;
  final dLat = _deg2rad(b.latitude - a.latitude);
  final dLng = _deg2rad(b.longitude - a.longitude);
  final la1 = _deg2rad(a.latitude), la2 = _deg2rad(b.latitude);
  final h =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(la1) * math.cos(la2) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return 2 * R * math.asin(math.sqrt(h));
}

double _deg2rad(double d) => d * math.pi / 180.0;

/// Tìm thành phố gần điểm [tap] nhất.
/// - Nếu [withinMeters] null, sẽ tự tính theo [zoom]:
///   threshold ≈ 25000 * (6 / zoom), clamp trong [minThreshold, maxThreshold] (m).
City? nearestCity(
  LatLng tap,
  List<City> cities, {
  double? withinMeters,
  double zoom = 6.0,
  double minThreshold = 3000,
  double maxThreshold = 30000,
}) {
  if (cities.isEmpty) return null;

  final threshold =
      withinMeters ??
      _clamp(25000.0 * (6.0 / zoom), minThreshold, maxThreshold);

  City? best;
  var bestD = double.infinity;
  for (final c in cities) {
    final d = distanceMeters(tap, c.latLng);
    if (d < bestD) {
      bestD = d;
      best = c;
    }
  }
  return (best != null && bestD <= threshold) ? best : null;
}

double _clamp(double v, double lo, double hi) =>
    v < lo ? lo : (v > hi ? hi : v);

/// Tìm theo tên (không phân biệt hoa/thường). Trả về city đầu tiên khớp.
City? findByName(String name, List<City> cities) {
  final q = name.trim().toLowerCase();
  for (final c in cities) {
    if (c.name.toLowerCase() == q) return c;
  }
  // Cho phép "contains" nếu không có match tuyệt đối
  for (final c in cities) {
    if (c.name.toLowerCase().contains(q)) return c;
  }
  return null;
}

/// Lọc các city nằm trong khung bản đồ [bounds].
List<City> filterByBounds(LatLngBounds bounds, List<City> cities) {
  return cities.where((c) {
    final p = c.latLng;
    return p.latitude >= bounds.south &&
        p.latitude <= bounds.north &&
        p.longitude >= bounds.west &&
        p.longitude <= bounds.east;
  }).toList();
}
