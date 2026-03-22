import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/api/subjectsapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/models/subject_model.dart';

final authTokenProvider = FutureProvider<String?>((ref) async {
  return  ref.watch(authControllerProvider.notifier).getToken();
});
class SubjectProvider extends AsyncNotifier<List<Subject>> {
  String course_id = "";

  @override
  Future<List<Subject>> build() async {
    // Don't manually set loading state - AsyncNotifier handles this
    final token = await ref.read(authTokenProvider.future);

    
    // If course_id is empty, return empty list or throw error
    if (course_id.isEmpty) {
      return [];
    }
    
    return subjectsget(token:token!, course_id:course_id);
  }

  void setcourse_id(String course) {
    course_id = course;
    // Trigger a rebuild after setting course_id
    ref.invalidateSelf();
  }

  // Refresh subjects list
  Future<void> refresh() async {
final token = await ref.read(authTokenProvider.future);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => subjectsget(token:token!, course_id:course_id));
  }
}

final subjectsNotifierProvider = 
  AsyncNotifierProvider<SubjectProvider, List<Subject>>(
    () => SubjectProvider(),
  );
