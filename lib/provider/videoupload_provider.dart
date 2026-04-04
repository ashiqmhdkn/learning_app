import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/models/video_model.dart';
import 'package:learning_app/utils/hive_serivce.dart';

class VideoProvider extends AsyncNotifier<List<Video>> {
  String unitId = "";

  @override
  Future<List<Video>> build() async {
    if (unitId.isEmpty) return [];
    return HiveService.getVideos(unitId);
  }

  // Set which unit to show videos for
  void setUnitId(String unit) {
    unitId = unit;
    ref.invalidateSelf();
  }}


final videosNotifierProvider =
    AsyncNotifierProvider<VideoProvider, List<Video>>(() => VideoProvider());

