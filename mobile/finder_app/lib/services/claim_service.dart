import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClaimService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/claims/';
  final _storage = const FlutterSecureStorage();

  Future<bool> submitClaim(int itemId, String description, List<String> proofImages) async {
    final token = await _storage.read(key: 'accessToken');
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'item': itemId,
        'description': description,
        // In a real app, proofImages would be uploaded separately
      }),
    );
    return response.statusCode == 201;
  }
}
