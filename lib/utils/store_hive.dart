import 'package:learning_app/models/unit_model.dart';
import 'package:learning_app/utils/hive_serivce.dart';
import '../models/user_model.dart';
import '../models/batch_model.dart';
import '../models/course_model.dart';
import '../models/subject_model.dart';
import '../models/video_model.dart';
import '../models/notes_model.dart';



// Safe cast helper — use everywhere instead of direct `as`
Map<String, dynamic> _toMap(dynamic value) {
  if (value == null) return {};
  if (value is Map<String, dynamic>) return value;
  return Map<String, dynamic>.from(value as Map);
}

List _toList(dynamic value) {
  if (value == null) return [];
  if (value is List) return value;
  return [];
}

String _str(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  return value.toString();
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

Future<void> storeHive(dynamic apiResponse) async {
  try {
    // ── Safe top-level unwrap ─────────────────────────────────────────────
    final Map<String, dynamic> response = _toMap(apiResponse);

    if (response.isEmpty) {
      print('❌ storeHive: apiResponse is null or empty');
      return;
    }

    print('📦 Raw response keys: ${response.keys}');

    //  final data = _toMap(response['data']);

    // if (data.isEmpty) {
    //   print('❌ storeHive: data field is missing or null');
    //   print('   Available keys: ${response.keys}');
    //   return;
    // }

    // ── 1. USER ──────────────────────────────────────────────────────────
    final userRaw = response['user'];
    if (userRaw == null) {
      print('❌ storeHive: user is null inside data');
      print('   data keys: ${response.keys}');
      return;
    }

    final userJson = _toMap(userRaw);
    final user = User.fromJson(userJson);
    await HiveService.saveUser(user);
    print('✅ User saved: ${user.username}');

    // ── 2. BATCHES ───────────────────────────────────────────────────────
    final batchesRaw = response['batches'];
    if (batchesRaw == null) {
      print('⚠️ No batches found in response');
      return;
    }

    final batchesMap = _toMap(batchesRaw);

    final List<Batch> batches = [];
    final List<Course> courses = [];
    final List<Subject> subjects = [];
    final List<Unit> units = [];
    final List<Video> videos = [];
    final List<Note> notes = [];

    for (final batchEntry in batchesMap.entries) {
      final batchData = _toMap(batchEntry.value);
      if (batchData.isEmpty) continue;

      // ── 3. BATCH ──────────────────────────────────────────────────────
      final courseRaw = batchData['course'];
      final courseData = _toMap(courseRaw);

      final batch = Batch(
        batchId:    _str(batchData['batch_id']),
        name:       _str(batchData['name']),
        batchImage: _str(batchData['batch_image']),
        courseId:   _str(courseData['course_id']),
        duration:   _str(batchData['duration']),
        createdAt:  _str(batchData['created_at']),
      );
      batches.add(batch);
      print('   📦 Batch: ${batch.name},${courseRaw}');

      if (courseData.isEmpty) continue;
      final courseId = _str(courseData['course_id']);
      if (courseId.isEmpty) continue;

      // ── 4. COURSE ─────────────────────────────────────────────────────
      final course = Course.fromJson({
        'course_id':    courseId,
        'title':        _str(courseData['title']),
        'description':  _str(courseData['description']),
        'course_image': _str(courseData['course_image']),
      });
      courses.add(course);
      print('   📚 Course: ${course.title}');

      // ── 5. SUBJECTS ───────────────────────────────────────────────────
      final subjectsRaw = courseData['subjects'];
      if (subjectsRaw == null) continue;
      final subjectsMap = _toMap(subjectsRaw);

      for (final subjectEntry in subjectsMap.entries) {
        final subjectData = _toMap(subjectEntry.value);
        if (subjectData.isEmpty) continue;

        final subjectId = _str(subjectData['subject_id']);
        if (subjectId.isEmpty) continue;

        final subject = Subject.fromJson({
          'subject_id':    subjectId,
          'title':         _str(subjectData['title']),
          'subject_image': _str(subjectData['subject_image']),
          'course_id':     courseId,
        });
        subjects.add(subject);
        print('   📖 Subject: ${subject.title}');

        // ── 6. UNITS ────────────────────────────────────────────────────
        final unitsRaw = subjectData['units'];
        if (unitsRaw == null) continue;
        final unitsMap = _toMap(unitsRaw);

        for (final unitEntry in unitsMap.entries) {
          final unitData = _toMap(unitEntry.value);
          if (unitData.isEmpty) continue;

          final unitId = _str(unitData['unit_id']);
          if (unitId.isEmpty) continue;

          final unit = Unit.fromJson({
            'unit_id':    unitId,
            'title':      _str(unitData['title']),
            'unit_image': _str(unitData['unit_image']),
            'subject_id': subjectId,
          });
          units.add(unit);
          print('   📂 Unit: ${unit.title}');

          // ── 7. VIDEOS ──────────────────────────────────────────────────
          for (final v in _toList(unitData['videos'])) {
            final vd = _toMap(v);
            if (vd.isEmpty) continue;
            final video = Video.fromJson({
              'video_id':      _str(vd['video_id']),
              'title':         _str(vd['title']),
              'unit_id':       unitId,
              'description':   _str(vd['description']),
              'duration':      _toDouble(vd['duration']),
              'video_url':     _str(vd['url'] ?? vd['video_url']),
              'thumbnail_url': _str(vd['thumbnail_url']),
              'status':        _str(vd['status'], 'active'),
            });
            videos.add(video);
          }

          // ── 8. NOTES ───────────────────────────────────────────────────
          for (final n in _toList(unitData['notes'])) {
            final nd = _toMap(n);
            if (nd.isEmpty) continue;
            final note = Note.fromJson({
              'note_id':    _str(nd['note_id']),
              'unit_id':    unitId,
              'title':      _str(nd['title']),
              'file_path':  nd['file_path'],
              'mime_type':  nd['mime_type'],
              'file_size':  nd['file_size'],
              'created_at': nd['created_at'],
            });
            notes.add(note);
          }
        }
      }
    }

    // ── SAVE ALL ─────────────────────────────────────────────────────────
    await HiveService.saveBatches(batches);
    await HiveService.saveCourses(courses);
    await HiveService.saveSubjects(subjects);
    await HiveService.saveUnits(units);
    await HiveService.saveVideos(videos);
    await HiveService.saveNotes(notes);

    print('✅ storeHive complete:');
    print('   Batches:  ${batches.length}');
    print('   Courses:  ${courses.length}');
    print('   Subjects: ${subjects.length}');
    print('   Units:    ${units.length}');
    print('   Videos:   ${videos.length}');
    print('   Notes:    ${notes.length}');

  } catch (e, stack) {
    print('❌ storeHive error: $e');
    print(stack);
  }
}