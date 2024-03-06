class MatchPasswordEvent {
  final bool isMatch;
  final int count;
  MatchPasswordEvent({
    required this.isMatch,
    required this.count,
  });
}
