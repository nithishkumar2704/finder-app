import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/item.dart';
import '../../models/chat.dart';
import '../../providers/chat_provider.dart';
import '../../services/chat_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.images.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: item.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      item.images[index].image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.itemType == 'LOST' ? Colors.red[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.itemType,
                          style: TextStyle(
                            color: item.itemType == 'LOST' ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        item.status.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.address ?? 'Location not specified',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text(item.postedByUsername[0].toUpperCase()),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Posted by', style: TextStyle(color: Colors.grey)),
                          Text(
                            item.postedByUsername,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Logic to start/get conversation
                      final storage = const FlutterSecureStorage();
                      final token = await storage.read(key: 'accessToken');
                      final response = await http.post(
                        Uri.parse('http://10.0.2.2:8000/api/chat/conversations/'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token',
                        },
                        body: jsonEncode({'item': item.id}),
                      );

                      if (response.statusCode == 201 || response.statusCode == 200) {
                        final conversation = Conversation.fromJson(jsonDecode(response.body));
                        if (context.mounted) {
                          Navigator.pushNamed(context, '/chat', arguments: conversation);
                        }
                      }
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Contact Finder/Owner'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/submit-claim', arguments: item);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Submit a Claim'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
