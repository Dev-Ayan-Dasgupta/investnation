import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/timer/index.dart';

class OTPTimerBloc extends Bloc<OTPTimerEvent, OTPTimerState> {
  OTPTimerBloc() : super(const OTPTimerState(seconds: 30)) {
    on<OTPTimerEvent>(
        (event, emit) => emit(OTPTimerState(seconds: event.seconds)));
  }
}
