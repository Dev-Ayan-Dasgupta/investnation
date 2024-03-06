import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';

class CreatePasswordBloc
    extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  CreatePasswordBloc()
      : super(
          const CreatePasswordState(allTrue: false),
        ) {
    on<CreatePasswordEvent>(
      (event, emit) => emit(
        CreatePasswordState(allTrue: event.allTrue),
      ),
    );
  }
}
