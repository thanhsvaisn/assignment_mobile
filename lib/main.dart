import 'package:flutter/material.dart'; // Import thư viện cơ bản của Flutter
import 'package:assignment/screens/splash_screen.dart'; // Import màn hình chào

void main() {
  runApp(const MyApp()); // Chạy app chính
}

class MyApp extends StatelessWidget { // Widget chính, không thay đổi trạng thái
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) { // Xây dựng giao diện
    return MaterialApp( // App Material Design (giao diện Android-like)
      title: 'Tech-Events Hub', // Tiêu đề app
      theme: ThemeData( // Theme màu sắc
        primarySwatch: Colors.blue, // Màu chính là xanh
      ),
      home: const SplashScreen(), // Màn hình đầu tiên là Splash
    );
  }
}