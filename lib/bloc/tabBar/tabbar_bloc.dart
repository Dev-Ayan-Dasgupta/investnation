import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/tabBar/tabbar_event.dart';
import 'package:investnation/bloc/tabBar/tabbar_state.dart';

class TabbarBloc extends Bloc<TabbarEvent, TabbarState> {
  TabbarBloc()
      : super(
          const TabbarState(index: 0),
        ) {
    on<TabbarEvent>(
      (event, emit) => emit(
        TabbarState(index: event.index),
      ),
    );
  }
}
