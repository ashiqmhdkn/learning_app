import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://api.crescentlearning.org';

Map<String, String> _headers(String token) => {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

// ─────────────────────────────────────────────
// BATCH CODE
// ─────────────────────────────────────────────


Future<bool> batchRequestSubmit({
  required String token,
  required String courseId,
  required String code,
}) async {
  final uri = Uri.parse('$baseUrl/courses/batch/request');
  try {
    final res = await http.post(
      uri,
      headers: _headers(token),
      body: jsonEncode({'course_id': courseId, 'code': code}),
    );
    print("token");
    print('batchRequestSubmit | ${res.statusCode} | ${res.body}');
    return res.statusCode == 200;
  } catch (e) {
    print('Error in batchRequestSubmit: $e');
    return false;
  }
}
// GET /courses/batch/students — Get students of a batch (admin)
