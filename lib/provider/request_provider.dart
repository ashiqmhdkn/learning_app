import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/api/requestapi.dart';
import 'package:learning_app/controller/authcontroller.dart';

// ─────────────────────────────────────────────
// AUTH TOKEN PROVIDER
// ─────────────────────────────────────────────

final authTokenProvider = FutureProvider<String?>((ref) async {
  return ref.watch(authControllerProvider.notifier).getToken();
});


// ─────────────────────────────────────────────
// BATCH REQUESTS PROVIDER
// ─────────────────────────────────────────────

class BatchRequestsNotifier extends AsyncNotifier<bool> {
  String _courseId = '';

  @override
  Future<bool> build() async => false;

  void setcourseId(String courseId) {
    _courseId = courseId;
    ref.invalidateSelf();
  }

  // Student submits a join request
  Future<bool> submitRequest({required String code}) async {
    final token = await ref.read(authTokenProvider.future);
    try {
      final success = await batchRequestSubmit(
        token: token!,
        courseId: _courseId,
        code: code,
      );
      return success;
    } catch (_) {
      return false;
    }
  }
}

final batchRequestsProvider =
    AsyncNotifierProvider<BatchRequestsNotifier, bool>(() => BatchRequestsNotifier());


// ─────────────────────────────────────────────
// BATCH STUDENTS PROVIDER
// ─────────────────────────────────────────────
