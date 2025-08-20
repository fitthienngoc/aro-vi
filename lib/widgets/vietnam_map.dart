// lib/vietnam_map.dart
//
// VietnamMap: Map OSM + highlight Việt Nam từ GeoJSON,
// tap để chọn thành phố gần nhất (tải từ assets/vn_cities.json).
//
// Props:
// - height/width: kích thước widget
// - enableMaskOutside: bật/tắt lớp mask tối ngoài VN
// - showCityMarkers: bật/tắt marker city
// - geoJsonAssetPath / citiesAssetPath: đường dẫn assets
// - onCitySelected: callback khi chọn được một City

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/widgets/utils/cities.dart';
import 'package:my_app/widgets/utils/geojson_vn.dart';

class VietnamMap extends StatefulWidget {
  final double width;
  final double height;
  final bool enableMaskOutside;
  final bool showCityMarkers;
  final String geoJsonAssetPath;
  final String citiesAssetPath;
  final ValueChanged<City>? onCitySelected;

  const VietnamMap({
    super.key,
    this.width = double.infinity,
    this.height = 400,
    this.enableMaskOutside = true,
    this.showCityMarkers = true,
    this.geoJsonAssetPath = 'assets/vn_outline.json', // hoặc .json
    this.citiesAssetPath = 'assets/vn_cities.json',
    this.onCitySelected,
  });

  @override
  State<VietnamMap> createState() => _VietnamMapState();
}

class _VietnamMapState extends State<VietnamMap> {
  final mapController = MapController();
  double _zoom = 5.0;

  late final Future _loadAll = _loadData();
  late List<PolygonRings> _vnPolys;
  late List<City> _cities;

  Future<void> _loadData() async {
    final polys = await loadVietnamPolygons(
      assetPath: widget.geoJsonAssetPath, // <-- dùng prop
    );
    final cities = await loadCities(
      assetPath: widget.citiesAssetPath, // <-- dùng prop
    );
    _vnPolys = polys;
    _cities = cities;
  }

  void _fitVietnam() {
    if (_vnPolys.isNotEmpty) {
      final b = boundsOf(_vnPolys);
      mapController.fitCamera(
        CameraFit.bounds(bounds: b, padding: const EdgeInsets.all(24)),
      );
    }
  }

  void _onMapTap(TapPosition _, LatLng latlng) {
    if (_cities.isEmpty) return;
    final city = nearestCity(latlng, _cities, zoom: mapController.camera.zoom);
    if (city != null) {
      if (widget.onCitySelected != null) widget.onCitySelected!(city);
      _showCitySheet(city);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hãy chạm gần một thành phố hơn hoặc zoom gần hơn.'),
        ),
      );
    }
  }

  void _showCitySheet(City city) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _CitySheet(city: city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          // Toolbar

          // Map
          Expanded(
            child: FutureBuilder(
              future: _loadAll,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Lỗi load dữ liệu: ${snap.error}'));
                }

                return Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(16.2, 107.9),
                        initialZoom: _zoom,
                        minZoom: 4,
                        maxZoom: 18,
                        onMapReady: () {
                          if (_vnPolys.isNotEmpty) _fitVietnam();
                        },
                        onTap: _onMapTap,
                        onMapEvent: (e) {
                          if (e is MapEventMoveEnd ||
                              e is MapEventFlingAnimationEnd) {
                            setState(() => _zoom = mapController.camera.zoom);
                          }
                        },
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.rotate,
                        ),
                      ),
                      children: [
                        // Tiles OSM
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),

                        // Mask tối ngoài VN (tuỳ chọn)
                        if (widget.enableMaskOutside && _vnPolys.isNotEmpty)
                          PolygonLayer(
                            polygons: [
                              Polygon(
                                // world rect (đổi thành thứ tự topo “vuông” này cho chắc)
                                points: const [
                                  LatLng(85, -180),
                                  LatLng(85, 180),
                                  LatLng(-85, 180),
                                  LatLng(-85, -180),
                                ],
                                holePointsList: [
                                  for (final p in _vnPolys) ...[
                                    p.outer,
                                    ...p.holes,
                                  ],
                                ],
                                color: Colors.black.withValues(
                                  alpha: 0.75,
                                ), // đậm để test
                                borderColor: Colors.transparent,
                              ),
                            ],
                          ),

                        // Highlight Việt Nam
                        if (_vnPolys.isNotEmpty)
                          PolygonLayer(
                            polygons: [
                              for (final p in _vnPolys)
                                Polygon(
                                  points: p.outer,
                                  holePointsList: p.holes,
                                  color: Colors.teal.withValues(alpha: 0.22),
                                  borderColor: Colors.teal,
                                  borderStrokeWidth: 2.0,
                                ),
                            ],
                          ),

                        // Marker city (tuỳ chọn)
                        if (widget.showCityMarkers && _cities.isNotEmpty)
                          MarkerLayer(
                            markers: [
                              for (final c in _cities)
                                Marker(
                                  point: c.latLng,
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: () => _showCitySheet(c),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 28,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                        const RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              '© OpenStreetMap contributors',
                            ),
                          ],
                        ),
                      ],
                    ),

                    // 🔹 Nút Fit Việt Nam (trước ở Row) -> overlay góc trên phải
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton.filledTonal(
                          tooltip: 'Fit Việt Nam',
                          onPressed: _fitVietnam,
                          icon: const Icon(Icons.fit_screen),
                        ),
                      ),
                    ),

                    // Nút zoom +/- (gọn)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ZoomBtn(
                            icon: Icons.add,
                            onTap: () => mapController.move(
                              mapController.camera.center,
                              (mapController.camera.zoom + 1).clamp(4, 18),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _ZoomBtn(
                            icon: Icons.remove,
                            onTap: () => mapController.move(
                              mapController.camera.center,
                              (mapController.camera.zoom - 1).clamp(4, 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 👉 Debug overlay ở góc trên bên trái
                    Positioned(
                      left: 8,
                      top: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            'polys: ${_vnPolys.length} • cities: ${_cities.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: icon.codePoint.toString(),
      onPressed: onTap,
      child: Icon(icon),
    );
  }
}

class _CitySheet extends StatelessWidget {
  final City city;
  const _CitySheet({required this.city});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_city),
                const SizedBox(width: 8),
                Text(city.name, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.place, size: 18),
                const SizedBox(width: 6),
                Text(
                  '(${city.latLng.latitude.toStringAsFixed(4)}, '
                  '${city.latLng.longitude.toStringAsFixed(4)})',
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
