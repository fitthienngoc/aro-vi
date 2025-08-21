import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers để quản lý nội dung của các trường nhập liệu
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Hàm xử lý đăng nhập giả lập
    // Chỉ kiểm tra xem người dùng đã nhập tên đăng nhập và mật khẩu chưa
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // Nếu đã nhập đủ thông tin, chuyển đến màn hình chính
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Nếu chưa nhập đủ thông tin, hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên đăng nhập và mật khẩu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold là widget cơ bản để tạo một màn hình hoàn chỉnh
      body: SafeArea(
        // SafeArea đảm bảo nội dung không bị che khuất bởi notch, status bar...
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Thêm padding xung quanh
          child: Column(
            // Column sắp xếp các widget con theo chiều dọc
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
            crossAxisAlignment: CrossAxisAlignment.stretch, // Mở rộng theo chiều ngang
            children: [
              const Text(
                'AROVIET',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center, // Căn giữa text
              ),
              const SizedBox(height: 48), // Tạo khoảng cách
              TextField(
                controller: _usernameController, // Kết nối với controller
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập', // Nhãn hiển thị
                  border: OutlineInputBorder(), // Viền xung quanh
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true, // Ẩn mật khẩu
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login, // Gọi hàm _login khi nhấn nút
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Đăng nhập', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Chuyển đến màn hình đăng ký
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Chưa có tài khoản? Đăng ký ngay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}