import 'package:equatable/equatable.dart';

class FolderModel extends Equatable {
  final int? id;
  final String path;
  final String name;
  final DateTime addedAt;

  const FolderModel({
    this.id,
    required this.path,
    required this.name,
    required this.addedAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'] as int?,
      path: map['path'] as String,
      name: map['name'] as String,
      addedAt: DateTime.parse(map['addedAt'] as String),
    );
  }

  FolderModel copyWith({
    int? id,
    String? path,
    String? name,
    DateTime? addedAt,
  }) {
    return FolderModel(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [id, path, name, addedAt];
}
