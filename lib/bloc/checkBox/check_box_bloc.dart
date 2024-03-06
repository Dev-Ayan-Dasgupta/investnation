import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc()
      : super(
          const CheckBoxState(isChecked: false),
        ) {
    on<CheckBoxEvent>(
      (event, emit) => emit(
        CheckBoxState(isChecked: event.isChecked),
      ),
    );
  }
}
