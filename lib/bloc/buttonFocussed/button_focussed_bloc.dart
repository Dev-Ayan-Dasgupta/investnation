import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';

class ButtonFocussedBloc
    extends Bloc<ButtonFocussedEvent, ButtonFocussedState> {
  ButtonFocussedBloc()
      : super(const ButtonFocussedState(
          isFocussed: false,
          toggles: 0,
        )) {
    on<ButtonFocussedEvent>(
      (event, emit) => emit(
        ButtonFocussedState(
          isFocussed: event.isFocussed,
          toggles: event.toggles,
        ),
      ),
    );
  }
}
