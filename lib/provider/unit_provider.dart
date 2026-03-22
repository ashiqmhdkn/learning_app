import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/api/unitsapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/models/unit_model.dart';

final authTokenProvider = FutureProvider<String?>((ref) async {
  return  ref.watch(authControllerProvider.notifier).getToken();
});

class UnitProvider extends AsyncNotifier<List<Unit>> {
  String subject_id = "";

  @override
  Future<List<Unit>> build() async {
    // Don't manually set loading state - AsyncNotifier handles this
    final token = await ref.read(authTokenProvider.future);
    // If subject_id is empty, return empty list or throw error
    if (subject_id.isEmpty) {
      return [];
    }
    
    return unitsget(token!,subject_id);
  }

  void setsubject_id(String subject) {
    subject_id = subject;
    // Trigger a rebuild after setting subject_id
    ref.invalidateSelf();
  }

  
  // Refresh units list
  Future<void> refresh() async {
final token = await ref.read(authTokenProvider.future);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => unitsget(token!, subject_id));
  }
}

final unitsNotifierProvider = 
  AsyncNotifierProvider<UnitProvider, List<Unit>>(
    () => UnitProvider(),
  );
