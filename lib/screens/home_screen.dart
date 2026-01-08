
import 'package:flutter/material.dart';
import 'package:assignment/screens/events_screen.dart'; // Import màn Events

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Chỉ số trang hiện tại
  final List<Widget> _pages = [ // Danh sách các trang
    const EventsScreen(), // Trang 1: Events
    const Center(child: Text('Trang Hồ Sơ')), // Trang 2: Placeholder (thay sau)
  ];

  void _onItemTapped(int index) { // Khi click item
    setState(() { // Cập nhật state
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Hiển thị trang hiện tại
      bottomNavigationBar: BottomNavigationBar( // Thanh dưới
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event), // Icon
            label: 'Sự Kiện', // Nhãn
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ Sơ',
          ),
        ],
        currentIndex: _selectedIndex, // Chỉ số hiện tại
        onTap: _onItemTapped, // Xử lý click
      ),
    );
  }
}