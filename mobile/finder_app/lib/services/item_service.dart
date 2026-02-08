import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/item.dart';

class ItemService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/items/';
  final _storage = const FlutterSecureStorage();

  Future<List<Item>> getItems({String? category, String? itemType, String? search}) async {
    Map<String, String> queryParams = {};
    if (category != null) queryParams['category'] = category;
    if (itemType != null) queryParams['item_type'] = itemType;
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Item.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<Item>> getNearbyItems(double lat, double lng, {double radius = 10}) async {
    final uri = Uri.parse('${baseUrl}nearby/').replace(queryParameters: {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'radius': radius.toString(),
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Item.fromJson(item)).toList();
    }
    return [];
  }

  Future<bool> postItem(Map<String, dynamic> itemData) async {
    final token = await _storage.read(key: 'accessToken');
    debugPrint('ItemService: Posting item with token: ${token?.substring(0, 5)}...');
    
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(itemData),
      );

      debugPrint('ItemService: Post item response: ${response.statusCode}');
      if (response.body.length > 500) {
        debugPrint('ItemService: Post item body (truncated): ${response.body.substring(0, 500)}...');
      } else {
        debugPrint('ItemService: Post item body: ${response.body}');
      }
      
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('ItemService: Error posting item: $e');
      return false;
    }
  }
}
