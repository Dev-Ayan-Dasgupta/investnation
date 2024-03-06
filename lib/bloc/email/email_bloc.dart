import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/email/index.dart';

class EmailValidationBloc
    extends Bloc<EmailValidationEvent, EmailValidationState> {
  EmailValidationBloc() : super(const EmailValidationState(isValid: false)) {
    on<EmailValidatedEvent>(
        (event, emit) => emit(EmailValidationState(isValid: event.isValid)));
    on<EmailInvalidatedEvent>(
        (event, emit) => emit(EmailValidationState(isValid: event.isValid)));
  }
}
