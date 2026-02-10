part of 'counter_bloc.dart';


@immutable
sealed class CounterBlocState {
  final int counter;

  const CounterBlocState({required this.counter});
}

class CounterInit extends CounterBlocState {
  const CounterInit() : super(counter: 0);
}

class CounterUpdate extends CounterBlocState {
  const CounterUpdate({required super.counter});
}
