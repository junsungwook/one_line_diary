import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/diary_entry.dart';

class DiaryService {
  static const String _boxName = 'diary_entries';
  late Box<DiaryEntry> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    Hive.registerAdapter(DiaryEntryAdapter());
    _box = await Hive.openBox<DiaryEntry>(_boxName);
  }

  /// 오늘 기록 저장 (이미 있으면 업데이트)
  Future<DiaryEntry> saveEntry(String content, {DateTime? date}) async {
    final targetDate = date ?? DateTime.now();
    final dateKey = _dateKey(targetDate);

    final existing = _box.get(dateKey);

    if (existing != null) {
      final updated = existing.copyWith(content: content);
      await _box.put(dateKey, updated);
      return updated;
    } else {
      final entry = DiaryEntry(
        id: _uuid.v4(),
        date: DateTime(targetDate.year, targetDate.month, targetDate.day),
        content: content,
        createdAt: DateTime.now(),
      );
      await _box.put(dateKey, entry);
      return entry;
    }
  }

  /// 특정 날짜 기록 조회
  DiaryEntry? getEntry(DateTime date) {
    return _box.get(_dateKey(date));
  }

  /// 특정 날짜 기록 삭제
  Future<void> deleteEntry(DateTime date) async {
    await _box.delete(_dateKey(date));
  }

  /// 기록된 모든 날짜 목록
  List<DateTime> getRecordedDates() {
    return _box.values.map((e) => e.date).toList();
  }

  /// 특정 월의 기록들
  List<DiaryEntry> getEntriesForMonth(int year, int month) {
    return _box.values
        .where((e) => e.date.year == year && e.date.month == month)
        .toList();
  }

  /// 모든 기록
  List<DiaryEntry> getAllEntries() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 날짜를 키로 변환 (yyyy-MM-dd)
  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
