import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/models/unit_model.dart';
import 'package:learning_app/utils/hive_serivce.dart';


class UnitProvider extends AsyncNotifier<List<Unit>> {
  String subject_id = "";

  @override
  Future<List<Unit>> build() async {
    // Don't manually set loading state - AsyncNotifier handles this
    // If subject_id is empty, return empty list or throw error
    if (subject_id.isEmpty) {
      return [];
    }
    
    return HiveService.getUnits(subject_id);
  }

  void setsubject_id(String subject) {
    subject_id = subject;
    // Trigger a rebuild after setting subject_id
    ref.invalidateSelf();
  }

  
  // Refresh units list

}

final unitsNotifierProvider = 
  AsyncNotifierProvider<UnitProvider, List<Unit>>(
    () => UnitProvider(),
  );
