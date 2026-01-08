import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:assignment/models/event.dart';
import 'package:assignment/screens/event_detail_sceen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // 🟢 CẤU HÌNH URL
  // Nếu dùng Android Emulator thì dùng 10.0.2.2
  // Nếu dùng Máy thật thì dùng IP LAN (ví dụ: 192.168.1.x)
  static const String baseUrl = 'http://10.0.2.2:1337';

  List<Event> _events = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  int _page = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchEvents();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchEvents(loadMore: true);
      }
    });
  }

  // LẤY DANH MỤC
  Future<void> _fetchCategories() async {
    const String url = '$baseUrl/api/categories';

    try {
      print('🔄 Đang gọi API Categories: $url');
      final response = await http.get(Uri.parse(url));

      // 🔴 QUAN TRỌNG: Kiểm tra xem màn hình còn đó không trước khi xử lý tiếp
      if (!mounted) return;

      print('📶 Status code Categories: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        if (data.isEmpty) {
          setState(() {
            _categories = ['All'];
          });
          return;
        }

        final List<String> cats = data.map<String>((cat) {
          return cat['name'] as String? ?? 'Danh mục không tên';
        }).toList();

        setState(() {
          _categories = ['All', ...cats];
        });
      } else {
        print('❌ Lỗi API Categories: ${response.body}');
      }
    } catch (e) {
      print('🚨 LỖI khi gọi API Categories: $e');
      // Kiểm tra mounted trước khi hiện thông báo
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải danh mục: $e')),
        );
      }
    }
  }

  // LẤY SỰ KIỆN
  Future<void> _fetchEvents({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    String url = '$baseUrl/api/events?pagination[page]=$_page&pagination[pageSize]=10';

    if (_selectedCategory != 'All') {
      // ⚠️ Lưu ý: Kiểm tra lại logic filter của bạn ở Strapi.
      // Thường filter theo Category sẽ là: filters[category][name][$eq]
      url += '&filters[name][\$eq]=$_selectedCategory';
    }

    try {
      print('🔄 Đang gọi API Events (trang $_page): $url');
      final response = await http.get(Uri.parse(url));

      // 🔴 QUAN TRỌNG: Nếu màn hình đã đóng, dừng lại ngay
      if (!mounted) return;

      print('📶 Status code Events: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        final List<Event> newEvents =
        data.map<Event>((json) => Event.fromJson(json)).toList();

        setState(() {
          if (loadMore) {
            _events.addAll(newEvents);
          } else {
            _events = newEvents;
          }
          _page++;
          _isLoading = false;
        });
      } else {
        print('❌ Lỗi API Events: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('🚨 LỖI khi gọi API Events: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải sự kiện: $e')),
        );
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _page = 1;
      _events.clear();
    });
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự Kiện'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: _categories.contains(_selectedCategory) ? _selectedCategory : null, // Fix lỗi nếu category chưa kịp load
              hint: const Text("Chọn"),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                if (value != null) _filterByCategory(value);
              },
            ),
          ),
        ],
      ),
      body: _events.isEmpty && !_isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _categories.isEmpty
                  ? 'Đang tải dữ liệu...'
                  : 'Chưa có sự kiện nào',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchCategories();
                _fetchEvents();
              },
              child: const Text('Tải lại'),
            ),
          ],
        ),
      )
          : ListView.builder(
        controller: _scrollController,
        itemCount: _events.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _events.length) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ));
          }
          final event = _events[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                event.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing:
              const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(
                      eventId: event.id,
                      name: event.name,
                      description: event.description,
                      date: null,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}