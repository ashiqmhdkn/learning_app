import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/models/notes_model.dart';
import 'package:learning_app/utils/hive_serivce.dart';


class NotesNotifier extends AsyncNotifier<List<Note>> {
  String unitId="";
  @override
  Future<List<Note>> build() async {
   
    return HiveService.getNotes( unitId);
  }
void setunit_id(String unit) {
    unitId = unit;
    ref.invalidateSelf();
  }

  
}

/// Usage:
///   ref.watch(notesNotifierProvider("unit_123"))
final notesNotifierProvider =
    AsyncNotifierProvider<NotesNotifier, List<Note>>(
      () => NotesNotifier(),
    );