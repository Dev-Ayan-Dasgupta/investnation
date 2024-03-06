import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/pinput/index.dart';

class PinputErrorBloc extends Bloc<PinputErrorEvent, PinputErrorState> {
  PinputErrorBloc()
      : super(const PinputErrorState(
          isError: false,
          isComplete: false,
          errorCount: 0,
        )) {
    on<PinputErrorEvent>((event, emit) => emit(PinputErrorState(
        isError: event.isError,
        isComplete: event.isComplete,
        errorCount: event.errorCount)));
  }
}
