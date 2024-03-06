import 'package:flutter_bloc/flutter_bloc.dart';
import 'index.dart';

class ShowButtonBloc extends Bloc<ShowButtonEvent, ShowButtonState> {
  ShowButtonBloc()
      : super(
          const ShowButtonState(show: false),
        ) {
    on<ShowButtonEvent>(
      (event, emit) => emit(
        ShowButtonState(show: event.show),
      ),
    );
  }
}
