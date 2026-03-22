import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/api/coursesapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/models/course_model.dart';

final authTokenProvider = FutureProvider<String?>((ref) async {
  return  ref.watch(authControllerProvider.notifier).getToken();
});

class CoursesNotifier extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    state = const AsyncValue.loading();
    final token = await ref.read(authTokenProvider.future);
    return coursesget(token!);
  }

  //
  // Refresh courses list
  Future<void> refresh() async {
    final token = await ref.read(authTokenProvider.future);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => coursesget(token!));
  }
}

final coursesNotifierProvider = 
  AsyncNotifierProvider<CoursesNotifier, List<Course>>(
    () => CoursesNotifier(),
  );