import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_app/models/unit_model.dart';
import '../models/user_model.dart';
import '../models/batch_model.dart';
import '../models/course_model.dart';
import '../models/subject_model.dart';
import '../models/video_model.dart';
import '../models/notes_model.dart';

/// Simple Hive service — no annotations, no build_runner.
/// Uses your existing models' toJson() / fromJson() directly.
class HiveService {
  // ─── Box names ───────────────────────────────────────────────────────────────
  static const String _userBox    = 'user';
  static const String _batchBox   = 'batches';
  static const String _courseBox  = 'courses';
  static const String _subjectBox = 'subjects';
  static const String _unitBox    = 'units';
  static const String _videoBox   = 'videos';
  static const String _noteBox    = 'notes';

  // ─── Open all boxes — call once in main.dart ─────────────────────────────────
  static Future<void> openAllBoxes() async {
    await Hive.openBox(_userBox);
    await Hive.openBox(_batchBox);
    await Hive.openBox(_courseBox);
    await Hive.openBox(_subjectBox);
    await Hive.openBox(_unitBox);
    await Hive.openBox(_videoBox);
    await Hive.openBox(_noteBox);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // USER
  // ════════════════════════════════════════════════════════════════════════════

  /// Save logged-in user
  static Future<void> saveUser(User user) async {
    await Hive.box(_userBox).put('current_user', user.toJson());
  }

  /// Get logged-in user (returns null if not saved)
  static User? getUser() {
    final raw = Hive.box(_userBox).get('current_user');
    if (raw == null) return null;
    return User.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Check if user is logged in
  static bool isLoggedIn() => Hive.box(_userBox).containsKey('current_user');

  /// Clear user on logout
  static Future<void> clearUser() async {
    await Hive.box(_userBox).delete('current_user');
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BATCH
  // Key: batchId
  // ════════════════════════════════════════════════════════════════════════════

  /// Save list of batches
  static Future<void> saveBatches(List<Batch> batches) async {
    final box = Hive.box(_batchBox);
    await box.clear();
    final map = {for (var b in batches) b.batchId: b.toJson()};
    await box.putAll(map);
  }

  /// Save single batch
  static Future<void> saveBatch(Batch batch) async {
    await Hive.box(_batchBox).put(batch.batchId, batch.toJson());
  }

  /// Get all batches
  static List<Batch> getBatches() {
    return Hive.box(_batchBox)
        .values
        .map((v) => Batch.fromJson(Map<String, dynamic>.from(v)))
        .toList();
  }

  /// Get single batch by id
  static Batch? getBatch(String batchId) {
    final raw = Hive.box(_batchBox).get(batchId);
    if (raw == null) return null;
    return Batch.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Delete single batch
  static Future<void> deleteBatch(String batchId) async {
    await Hive.box(_batchBox).delete(batchId);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // COURSE
  // Key: courseId
  // ════════════════════════════════════════════════════════════════════════════

  /// Save list of courses
  static Future<void> saveCourses(List<Course> courses) async {
    final box = Hive.box(_courseBox);
    await box.clear();
    final map = {for (var c in courses) c.course_id!: c.toJson()};
    await box.putAll(map);
  }

  /// Save single course
  static Future<void> saveCourse(Course course) async {
    if (course.course_id == null) return;
    await Hive.box(_courseBox).put(course.course_id, course.toJson());
  }

  /// Get all courses
  static List<Course> getCourses() {
    return Hive.box(_courseBox)
        .values
        .map((v) => Course.fromJson(Map<String, dynamic>.from(v)))
        .toList();
  }

  /// Get single course by id
  static Course? getCourse(String courseId) {
    final raw = Hive.box(_courseBox).get(courseId);
    if (raw == null) return null;
    return Course.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Delete single course
  static Future<void> deleteCourse(String courseId) async {
    await Hive.box(_courseBox).delete(courseId);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SUBJECT
  // Key: courseId_subjectId  (prefix by courseId to filter per course)
  // ════════════════════════════════════════════════════════════════════════════

  /// Save list of subjects for a course
  static Future<void> saveSubjects(List<Subject> subjects) async {
    final box = Hive.box(_subjectBox);
    for (final s in subjects) {
      await box.put('${s.course_id}_${s.subject_id}', s.toJson());
    }
  }

  /// Save single subject
  static Future<void> saveSubject(Subject subject) async {
    await Hive.box(_subjectBox)
        .put('${subject.course_id}_${subject.subject_id}', subject.toJson());
  }

  /// Get all subjects for a course
  static List<Subject> getSubjects(String courseId) {
    final box = Hive.box(_subjectBox);
    return box.keys
        .where((k) => k.toString().startsWith('${courseId}_'))
        .map((k) => Subject.fromJson(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  /// Get single subject
  static Subject? getSubject(String courseId, String subjectId) {
    final raw = Hive.box(_subjectBox).get('${courseId}_$subjectId');
    if (raw == null) return null;
    return Subject.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Delete all subjects for a course
  static Future<void> deleteSubjects(String courseId) async {
    final box = Hive.box(_subjectBox);
    final keys = box.keys
        .where((k) => k.toString().startsWith('${courseId}_'))
        .toList();
    await box.deleteAll(keys);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // UNIT
  // Key: subjectId_unitId  (prefix by subjectId to filter per subject)
  // ════════════════════════════════════════════════════════════════════════════

  /// Save list of units for a subject
  static Future<void> saveUnits(List<Unit> units) async {
    final box = Hive.box(_unitBox);
    for (final u in units) {
      await box.put('${u.subject_id}_${u.unit_id}', u.toJson());
    }
  }

  /// Save single unit
  static Future<void> saveUnit(Unit unit) async {
    await Hive.box(_unitBox)
        .put('${unit.subject_id}_${unit.unit_id}', unit.toJson());
  }

  /// Get all units for a subject
  static List<Unit> getUnits(String subjectId) {
    final box = Hive.box(_unitBox);
    return box.keys
        .where((k) => k.toString().startsWith('${subjectId}_'))
        .map((k) => Unit.fromJson(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  /// Get single unit
  static Unit? getUnit(String subjectId, String unitId) {
    final raw = Hive.box(_unitBox).get('${subjectId}_$unitId');
    if (raw == null) return null;
    return Unit.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Delete all units for a subject
  static Future<void> deleteUnits(String subjectId) async {
    final box = Hive.box(_unitBox);
    final keys = box.keys
        .where((k) => k.toString().startsWith('${subjectId}_'))
        .toList();
    await box.deleteAll(keys);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // VIDEO
  // Key: unitId_videoId  (prefix by unitId to filter per unit)
  // ════════════════════════════════════════════════════════════════════════════

  /// Save list of videos for a unit
  static Future<void> saveVideos(List<Video> videos) async {
    final box = Hive.box(_videoBox);
    for (final v in videos) {
      await box.put('${v.unit_id}_${v.video_id}', v.toJson());
    }
  }

  /// Save single video
  static Future<void> saveVideo(Video video) async {
    await Hive.box(_videoBox)
        .put('${video.unit_id}_${video.video_id}', video.toJson());
  }

  /// Get all videos for a unit
  static List<Video> getVideos(String unitId) {
    final box = Hive.box(_videoBox);
    return box.keys
        .where((k) => k.toString().startsWith('${unitId}_'))
        .map((k) => Video.fromJson(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  /// Get single video
  static Video? getVideo(String unitId, String videoId) {
    final raw = Hive.box(_videoBox).get('${unitId}_$videoId');
    if (raw == null) return null;
    return Video.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Delete all videos for a unit
  static Future<void> deleteVideos(String unitId) async {
    final box = Hive.box(_videoBox);
    final keys = box.keys
        .where((k) => k.toString().startsWith('${unitId}_'))
        .toList();
    await box.deleteAll(keys);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // NOTE
  // Key: unitId_noteId  (prefix by unitId to filter per unit)
  // ════════════════════════════════════════════════════════════════════════════

  /// Save list of notes for a unit
  static Future<void> saveNotes(List<Note> notes) async {
    final box = Hive.box(_noteBox);
    for (final n in notes) {
      await box.put('${n.unitId}_${n.noteId}', n.toJson());
    }
  }

  /// Save single note
  static Future<void> saveNote(Note note) async {
    await Hive.box(_noteBox)
        .put('${note.unitId}_${note.noteId}', note.toJson());
  }

  /// Get all notes for a unit
  static List<Note> getNotes(String unitId) {
    final box = Hive.box(_noteBox);
    return box.keys
        .where((k) => k.toString().startsWith('${unitId}_'))
        .map((k) => Note.fromJson(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  /// Get single note
  static Note? getNote(String unitId, String noteId) {
    final raw = Hive.box(_noteBox).get('${unitId}_$noteId');
    if (raw == null) return null;
    return Note.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Delete all notes for a unit
  static Future<void> deleteNotes(String unitId) async {
    final box = Hive.box(_noteBox);
    final keys = box.keys
        .where((k) => k.toString().startsWith('${unitId}_'))
        .toList();
    await box.deleteAll(keys);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // CLEAR ALL  (call on logout)
  // ════════════════════════════════════════════════════════════════════════════

  static Future<void> clearAll() async {
    await Hive.box(_userBox).clear();
    await Hive.box(_batchBox).clear();
    await Hive.box(_courseBox).clear();
    await Hive.box(_subjectBox).clear();
    await Hive.box(_unitBox).clear();
    await Hive.box(_videoBox).clear();
    await Hive.box(_noteBox).clear();
  }
}