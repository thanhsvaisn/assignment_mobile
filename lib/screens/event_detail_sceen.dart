import 'package:flutter/material.dart';
import 'package:assignment/screens/registration_form.dart';

class EventDetailScreen extends StatelessWidget {
  final int eventId;
  final String name;
  final String description;
  final String? date; // Có thể null nếu chưa có dữ liệu ngày

  const EventDetailScreen({
    super.key,
    required this.eventId,
    required this.name,
    required this.description,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sự Kiện'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sự kiện (tạm dùng placeholder, sau thêm thật)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: const Icon(
                Icons.event,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Tên sự kiện
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Ngày giờ (nếu có)
            if (date != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Ngày: $date',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Mô tả
            const Text(
              'Mô tả',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 40),

            // Nút đăng ký
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationForm(eventId: eventId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('ĐĂNG KÝ THAM GIA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}