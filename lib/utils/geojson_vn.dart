// geojson_vn.dart
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PolygonRings {
  final List<LatLng> outer;
  final List<List<LatLng>> holes;
  PolygonRings({required this.outer, List<List<LatLng>>? holes})
    : holes = holes ?? const [];
}

/// Đọc GeoJSON outline VN và trả về danh sách PolygonRings
Future<List<PolygonRings>> loadVietnamPolygons({
  String assetPath = 'assets/vn_outline.json',
}) async {
  final raw = await rootBundle.loadString(assetPath);
  final geo = json.decode(raw);

  final List<PolygonRings> result = [];

  List<LatLng> toRing(List ring) => [
    for (final c in ring)
      LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
  ];

  void collect(Map<String, dynamic> g) {
    final type = g['type'];
    final coords = g['coordinates'];
    if (type == 'Polygon') {
      final rings = coords as List;
      if (rings.isNotEmpty) {
        result.add(
          PolygonRings(
            outer: toRing(rings.first),
            holes: [for (int i = 1; i < rings.length; i++) toRing(rings[i])],
          ),
        );
      }
    } else if (type == 'MultiPolygon') {
      for (final poly in coords as List) {
        final rings = poly as List;
        if (rings.isNotEmpty) {
          result.add(
            PolygonRings(
              outer: toRing(rings.first),
              holes: [for (int i = 1; i < rings.length; i++) toRing(rings[i])],
            ),
          );
        }
      }
    }
  }

  // Xử lý nhiều dạng GeoJSON khác nhau
  if (geo['type'] == 'FeatureCollection') {
    for (final f in geo['features']) {
      collect(Map<String, dynamic>.from(f['geometry']));
    }
  } else if (geo['type'] == 'Feature') {
    collect(Map<String, dynamic>.from(geo['geometry']));
  } else if (geo['type'] == 'GeometryCollection') {
    for (final g in geo['geometries']) {
      collect(Map<String, dynamic>.from(g));
    }
  } else {
    collect(Map<String, dynamic>.from(geo));
  }

  return result;
}

LatLngBounds boundsOf(List<PolygonRings> polys) {
  double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
  for (final p in polys) {
    for (final pt in p.outer) {
      minLat = math.min(minLat, pt.latitude);
      maxLat = math.max(maxLat, pt.latitude);
      minLng = math.min(minLng, pt.longitude);
      maxLng = math.max(maxLng, pt.longitude);
    }
  }
  return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
}
