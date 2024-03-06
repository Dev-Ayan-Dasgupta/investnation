import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';

class DropdownSelectedBloc
    extends Bloc<DropdownSelectedEvent, DropdownSelectedState> {
  DropdownSelectedBloc()
      : super(
          const DropdownSelectedState(
            isDropdownSelected: false,
            toggles: 0,
          ),
        ) {
    on<DropdownSelectedEvent>(
      (event, emit) => emit(
        DropdownSelectedState(
          isDropdownSelected: event.isDropdownSelected,
          toggles: event.toggles,
        ),
      ),
    );
  }
}
