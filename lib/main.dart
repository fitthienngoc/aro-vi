import 'package:flutter/material.dart';
import 'screens/login/screen.dart';
import 'screens/register/screen.dart';
import 'screens/home/screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AROVIET', // Tiêu đề ứng dụng
      debugShowCheckedModeBanner: false, // Ẩn banner "Debug" ở góc phải
      theme: ThemeData(
        primarySwatch: Colors.blue, // Màu chủ đạo của ứng dụng
        visualDensity: VisualDensity.adaptivePlatformDensity, // Điều chỉnh mật độ hiển thị
      ),
      home: const LoginScreen(), // Màn hình khởi đầu là màn hình đăng nhập
      routes: {
        // Định nghĩa các route để điều hướng giữa các màn hình
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
