abstract class ShowPasswordEvent {}

class DisplayPasswordEvent extends ShowPasswordEvent {
  final bool showPassword;
  final int toggle;
  DisplayPasswordEvent({
    required this.showPassword,
    required this.toggle,
  });
}

class HidePasswordEvent extends ShowPasswordEvent {
  final bool showPassword;
  final int toggle;
  HidePasswordEvent({
    required this.showPassword,
    required this.toggle,
  });
}
