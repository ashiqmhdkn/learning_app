import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/unit_model.dart';

const String baseUrl = 'https://api.crescentlearning.org';

// GET - Fetch all units
Future<List<Unit>> unitsget(String token,String subjectId) async {
  final uri = Uri.parse('$baseUrl/units?subject_id=$subjectId');
  try {
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    
    print('GET units Response: ${response.statusCode} api $uri');
    print('GET units Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('units')) {
        final unitsList = data['units'] as List;
        return unitsList
            .map((item) => Unit.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('units data not found in response');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to fetch units');
    }
  } catch (e) {
    print('Error in unitsget: $e');
    rethrow;
  }
}
