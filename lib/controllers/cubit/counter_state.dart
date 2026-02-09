part of 'counter_cubit.dart';

@immutable
sealed class CounterState {
  final int counter;

  const CounterState({required this.counter});
}

class CounterInit extends CounterState {
  const CounterInit() : super(counter: 0);
}

class CounterUpdate extends CounterState {
  const CounterUpdate({required super.counter});
}
