import 'package:flutter/material.dart';
import 'package:my_app/screens/home/tabs/feed/screen.dart';
import 'package:my_app/screens/home/tabs/explore/screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với từng tab
  final List<Widget> _screens = [
    const FeedTab(), // Sử dụng FeedTab từ file riêng
    const ExploreTab(), // Sử dụng ExploreTab từ file riêng
    const MessTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      body:
          _screens[_selectedIndex], // Hiển thị màn hình tương ứng với tab được chọn
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Hiển thị nhãn cho tất cả các tab
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mess'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Tab Mess - nơi nhắn tin
class MessTab extends StatelessWidget {
  const MessTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mess Tab - Nơi nhắn tin', style: TextStyle(fontSize: 18)),
    );
  }
}

// Tab Profile - nơi quản lý thông tin tài khoản
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Tab - Nơi quản lý thông tin tài khoản',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
