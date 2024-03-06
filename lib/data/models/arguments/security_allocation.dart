// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SecurityAllocationArgumentModel {
  final List securityDetails;
  SecurityAllocationArgumentModel({
    required this.securityDetails,
  });

  SecurityAllocationArgumentModel copyWith({
    List? securityDetails,
  }) {
    return SecurityAllocationArgumentModel(
      securityDetails: securityDetails ?? this.securityDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'securityDetails': securityDetails,
    };
  }

  factory SecurityAllocationArgumentModel.fromMap(Map<String, dynamic> map) {
    return SecurityAllocationArgumentModel(
      securityDetails: List.from((map['securityDetails'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory SecurityAllocationArgumentModel.fromJson(String source) =>
      SecurityAllocationArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SecurityAllocationArgumentModel(securityDetails: $securityDetails)';

  @override
  bool operator ==(covariant SecurityAllocationArgumentModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.securityDetails, securityDetails);
  }

  @override
  int get hashCode => securityDetails.hashCode;
}
