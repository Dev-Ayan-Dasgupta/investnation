import 'package:equatable/equatable.dart';

class ShowPasswordState extends Equatable {
  final bool showPassword;
  final int toggle;

  const ShowPasswordState({
    required this.showPassword,
    required this.toggle,
  });
  @override
  List<Object?> get props => [showPassword, toggle];
}
