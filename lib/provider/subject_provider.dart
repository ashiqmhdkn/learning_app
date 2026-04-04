import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/models/subject_model.dart';
import 'package:learning_app/utils/hive_serivce.dart';

class SubjectProvider extends AsyncNotifier<List<Subject>> {
  String course_id = "";

  @override
  Future<List<Subject>> build() async {
    // Don't manually set loading state - AsyncNotifier handles this
    
    // If course_id is empty, return empty list or throw error
    if (course_id.isEmpty) {
      return [];
    }
    
    return HiveService.getSubjects(course_id);
  }

  void setcourse_id(String course) {
    course_id = course;
    // Trigger a rebuild after setting course_id
    ref.invalidateSelf();
  }
}

final subjectsNotifierProvider = 
  AsyncNotifierProvider<SubjectProvider, List<Subject>>(
    () => SubjectProvider(),
  );
