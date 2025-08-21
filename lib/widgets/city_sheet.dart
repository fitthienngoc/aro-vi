// lib/widgets/city_sheet.dart
//
// CitySheet: Widget hiển thị thông tin chi tiết của một thành phố
// dưới dạng bottom sheet với menu từ trên xuống dưới.
//
// Được sử dụng trong VietnamMap khi người dùng chọn một thành phố.

import 'package:flutter/material.dart';
import 'package:my_app/widgets/utils/cities.dart';

class CitySheet extends StatelessWidget {
  final City city;

  const CitySheet({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước của thanh điều hướng để thêm padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // Đặt chiều cao tối thiểu để đảm bảo sheet đủ cao
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85, // 85% chiều cao màn hình
        minHeight: MediaQuery.of(context).size.height * 0.6, // ít nhất 60% chiều cao màn hình
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Tiêu đề thành phố
          _buildCityHeader(context),
          const SizedBox(height: 12),

          // Tọa độ
          _buildCoordinates(),
          const SizedBox(height: 16),

          // Menu từ trên xuống dưới
        Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 16 + bottomPadding),
              children: [
                _buildMenuSection(
                  title: 'Thông tin chung',
                  icon: Icons.info_outline,
                  onTap: () {
                    debugPrint('Đã chọn thông tin chung của ${city.name}');
                  },
          ),

                // Mục lịch sử
                _buildMenuSection(
                  title: 'Lịch sử',
                  icon: Icons.history_edu,
                  onTap: () {
                    debugPrint('Đã chọn lịch sử của ${city.name}');
                    // Có thể mở một trang mới hoặc hiển thị dialog với thông tin lịch sử
                  },
        ),

                // Mục ẩm thực
                _buildMenuSection(
                  title: 'Ẩm thực đặc sản',
                  icon: Icons.restaurant_menu,
                  onTap: () {
                    debugPrint('Đã chọn ẩm thực của ${city.name}');
                    // Có thể hiển thị danh sách món ăn đặc sản của thành phố
                  },
        ),

                // Mục danh nhân văn hóa
                _buildMenuSection(
                  title: 'Danh nhân văn hóa',
                  icon: Icons.people_alt_outlined,
                  onTap: () {
                    debugPrint(
                      'Đã chọn danh nhân văn hóa của ${city.name}',
    );
                    // Hiển thị danh sách các danh nhân nổi tiếng của thành phố
                  },
        ),

                // Mục di tích lịch sử
                _buildMenuSection(
                  title: 'Di tích lịch sử',
                  icon: Icons.account_balance,
                  onTap: () {
                    debugPrint('Đã chọn di tích lịch sử của ${city.name}');
                    // Hiển thị danh sách các di tích lịch sử của thành phố
                  },
                ),

                // Mục lễ hội truyền thống
                _buildMenuSection(
                  title: 'Lễ hội truyền thống',
                  icon: Icons.celebration,
                  onTap: () {
                    debugPrint(
                      'Đã chọn lễ hội truyền thống của ${city.name}',
                    );
                    // Hiển thị thông tin về các lễ hội truyền thống của thành phố
                  },
                ),

                _buildMenuSection(
                  title: 'Địa điểm nổi bật',
                  icon: Icons.place,
                  onTap: () {
                    debugPrint('Đã chọn địa điểm nổi bật của ${city.name}');
                  },
        ),

                _buildMenuSection(
                  title: 'Thời tiết',
                  icon: Icons.cloud,
                  onTap: () {
                    debugPrint('Đã chọn thời tiết của ${city.name}');
                  },
      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị tiêu đề thành phố
  Widget _buildCityHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_city),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            city.name,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Thêm nút đóng ở góc phải của header
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Đóng',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
}

  // Widget hiển thị tọa độ
  Widget _buildCoordinates() {
    return Row(
      children: [
        const Icon(Icons.place, size: 18),
        const SizedBox(width: 6),
        Text(
          '(${city.latLng.latitude.toStringAsFixed(4)}, '
          '${city.latLng.longitude.toStringAsFixed(4)})',
        ),
      ],
    );
  }

  // Widget tạo một mục menu
  Widget _buildMenuSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}