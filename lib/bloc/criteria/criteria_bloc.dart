import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';

class CriteriaBloc extends Bloc<CriteriaEvent, CriteriaState> {
  CriteriaBloc() : super(CriteriaState()) {
    on<CriteriaMin8Event>(
        (event, emit) => emit(CriteriaMin8State(hasMin8: event.hasMin8)));
    on<CriteriaNumericEvent>((event, emit) =>
        emit(CriteriaNumericState(hasNumeric: event.hasNumeric)));
    on<CriteriaUpperLowerEvent>((event, emit) =>
        emit(CriteriaUpperLowerState(hasUpperLower: event.hasUpperLower)));
    on<CriteriaSpecialEvent>((event, emit) =>
        emit(CriteriaSpecialState(hasSpecial: event.hasSpecial)));
  }
}
