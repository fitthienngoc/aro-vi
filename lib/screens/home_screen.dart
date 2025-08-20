import 'package:flutter/material.dart';
import '../widgets/vietnam_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AROVIET'),
        actions: [
          // Nút đăng xuất ở góc phải của AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Khi nhấn nút đăng xuất, quay lại màn hình đăng nhập
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sử dụng widget VietnamMap với kích thước cố định
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VietnamMap(
                enableMaskOutside: true,
                showCityMarkers:
                    true, // nếu muốn chỉ tap để chọn, không hiển thị marker
                onCitySelected: (c) {
                  debugPrint('Chọn thành phố: ${c.name}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
