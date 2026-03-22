import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/subject_model.dart';

const String baseUrl = 'https://api.crescentlearning.org';

// GET - Fetch all subjects
Future<List<Subject>> subjectsget({required String token,required String course_id}) async {
  final uri = Uri.parse('$baseUrl/subjects?course_id=$course_id');
  try {
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    
    print('GET subjects Response: ${response.statusCode}');
    print('GET subjects Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('subjects')) {
        final subjectsList = data['subjects'] as List;
        return subjectsList
            .map((item) => Subject.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('subjects data not found in response');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to fetch subjects');
    }
  } catch (e) {
    print('Error in subjectsget: $e');
    rethrow;
  }
}