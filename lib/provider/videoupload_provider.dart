import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/api/videoupload.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/models/video_model.dart';

final authTokenProvider = FutureProvider<String?>((ref) async {
  return ref.watch(authControllerProvider.notifier).getToken();
});

class VideoService {
  final String token;

  VideoService(this.token);

  // Fetch all videos for a unit
  Future<List<Video>> fetchVideos(String unitId) async {
    return await videosGet(token, unitId);
  }
}

//   // Delete video
//   Future<bool> deleteVideo(String videoId) async {
//     return await videoDelete(token: token, videoId: videoId);
//   }

final videoServiceProvider = Provider<VideoService>((ref) {
  final token = ref.watch(authTokenProvider).value;
  if (token == null) throw Exception('No token available');
  return VideoService(token);
});

class VideoProvider extends AsyncNotifier<List<Video>> {
  String unitId = "";

  @override
  Future<List<Video>> build() async {
    if (unitId.isEmpty) return [];

    final service = ref.read(videoServiceProvider);
    return service.fetchVideos(unitId);
  }

  // Set which unit to show videos for
  void setUnitId(String unit) {
    unitId = unit;
    ref.invalidateSelf();
  }

  // Reload videos from server
  Future<void> refresh() async {
    if (unitId.isEmpty) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(videoServiceProvider);
      return service.fetchVideos(unitId);
    });
  }}

//   // Delete video
//   Future<bool> deleteVideo(String videoId) async {
//     final service = ref.read(videoServiceProvider);

//     final success = await service.deleteVideo(videoId);

//     if (success) await refresh();
//     return success;
//   }
// }

final videosNotifierProvider =
    AsyncNotifierProvider<VideoProvider, List<Video>>(() => VideoProvider());

