import 'package:flutter/material.dart';
import 'package:my_app/widgets/vietnam_map.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sử dụng Expanded để VietnamMap chiếm toàn bộ không gian có sẵn
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VietnamMap(
              enableMaskOutside: true,
              showCityMarkers: true,
              onCitySelected: (c) {
                debugPrint('Chọn thành phố: ${c.name}');
              },
            ),
          ),
        ),
      ],
    );
  }
}