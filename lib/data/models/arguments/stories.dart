// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoriesArgumentModel {
  final bool isBiometric;
  StoriesArgumentModel({
    required this.isBiometric,
  });

  StoriesArgumentModel copyWith({
    bool? isBiometric,
  }) {
    return StoriesArgumentModel(
      isBiometric: isBiometric ?? this.isBiometric,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBiometric': isBiometric,
    };
  }

  factory StoriesArgumentModel.fromMap(Map<String, dynamic> map) {
    return StoriesArgumentModel(
      isBiometric: map['isBiometric'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoriesArgumentModel.fromJson(String source) =>
      StoriesArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StoriesArgumentModel(isBiometric: $isBiometric)';

  @override
  bool operator ==(covariant StoriesArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isBiometric == isBiometric;
  }

  @override
  int get hashCode => isBiometric.hashCode;
}
