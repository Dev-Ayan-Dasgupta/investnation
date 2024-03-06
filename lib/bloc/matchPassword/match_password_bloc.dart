import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/matchPassword/index.dart';

class MatchPasswordBloc extends Bloc<MatchPasswordEvent, MatchPasswordState> {
  MatchPasswordBloc()
      : super(
          const MatchPasswordState(
            isMatch: true,
            count: 0,
          ),
        ) {
    on<MatchPasswordEvent>(
      (event, emit) => emit(
        MatchPasswordState(
          isMatch: event.isMatch,
          count: event.count,
        ),
      ),
    );
  }
}
