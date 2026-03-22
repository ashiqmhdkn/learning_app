import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/course_model.dart';

const String baseUrl = 'https://api.crescentlearning.org';

// GET - Fetch all courses
Future<List<Course>> coursesget(String token) async {
  final uri = Uri.parse('$baseUrl/courses');
  try {
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    
    print('GET Courses Response: ${response.statusCode}');
    print("==============================================object===============================================================");
    print('GET Courses Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('courses')) {
        final coursesList = data['courses'] as List;
        return coursesList
            .map((item) => Course.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Courses data not found in response');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to fetch courses');
    }
  } catch (e) {
    print('Error in coursesget: $e');
    rethrow;
  }
}
