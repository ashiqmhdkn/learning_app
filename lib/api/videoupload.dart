import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/video_model.dart';

const String baseUrl = 'https://api.crescentlearning.org';

Future<List<Video>> videosGet(String token, String unit_id) async {
  final uri = Uri.parse('$baseUrl/unit/videos?unit_id=$unit_id');

  try {
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print('Videos API Status: ${response.statusCode}');
    print('Videos API Body: ${response.body}');

    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('application/json')) {
      throw Exception('Server did not return JSON');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('videos')) {
        final videosList = data['videos'] as List;
        return videosList
            .map((item) => Video.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('videos key missing in response');
      }
    }

    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired');
    }

    throw Exception('Server error: ${response.statusCode}');
  } catch (e) {
    print('❌ Error in videosGet: $e');
    rethrow;
  }
}
