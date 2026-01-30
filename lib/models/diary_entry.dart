import 'package:hive/hive.dart';

class DiaryEntry extends HiveObject {
  final String id;
  final DateTime date;
  final String content;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
  });

  DiaryEntry copyWith({
    String? id,
    DateTime? date,
    String? content,
    DateTime? createdAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DiaryEntryAdapter extends TypeAdapter<DiaryEntry> {
  @override
  final int typeId = 0;

  @override
  DiaryEntry read(BinaryReader reader) {
    final id = reader.readString();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final content = reader.readString();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    // Skip mood field if present (backward compatibility)
    try {
      if (reader.availableBytes > 0) {
        reader.readInt();
      }
    } catch (_) {}

    return DiaryEntry(
      id: id,
      date: date,
      content: content,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryEntry obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.content);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
