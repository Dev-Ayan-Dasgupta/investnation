import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/scrolDirection/index.dart';

class ScrollDirectionBloc
    extends Bloc<ScrollDirectionEvent, ScrollDirectionState> {
  ScrollDirectionBloc()
      : super(
          const ScrollDirectionState(scrollDown: true),
        ) {
    on<ScrollDirectionEvent>(
      (event, emit) => emit(
        ScrollDirectionState(scrollDown: event.scrollDown),
      ),
    );
  }
}
