import 'package:equatable/equatable.dart';

class MatchPasswordState extends Equatable {
  final bool isMatch;
  final int count;
  const MatchPasswordState({
    required this.isMatch,
    required this.count,
  });

  @override
  List<Object?> get props => [isMatch, count];
}
