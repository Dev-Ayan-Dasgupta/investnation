import 'package:event_bus/event_bus.dart';

class EventBusFactory {
  static EventBus? eventBus;

  static EventBus getInstance() {
    eventBus ??= EventBus();

    return eventBus!;
  }
}
