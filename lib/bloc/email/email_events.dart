abstract class EmailValidationEvent {}

class EmailValidatedEvent extends EmailValidationEvent {
  final bool isValid;
  EmailValidatedEvent({
    required this.isValid,
  });
}

class EmailInvalidatedEvent extends EmailValidationEvent {
  final bool isValid;
  EmailInvalidatedEvent({
    required this.isValid,
  });
}
