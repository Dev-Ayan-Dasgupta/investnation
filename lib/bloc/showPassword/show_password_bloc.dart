import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';

class ShowPasswordBloc extends Bloc<ShowPasswordEvent, ShowPasswordState> {
  ShowPasswordBloc()
      : super(
          const ShowPasswordState(showPassword: false, toggle: 0),
        ) {
    on<DisplayPasswordEvent>(
      (event, emit) => emit(
        ShowPasswordState(
          showPassword: event.showPassword,
          toggle: event.toggle,
        ),
      ),
    );
    on<HidePasswordEvent>(
      (event, emit) => emit(
        ShowPasswordState(
          showPassword: event.showPassword,
          toggle: event.toggle,
        ),
      ),
    );
  }
}
