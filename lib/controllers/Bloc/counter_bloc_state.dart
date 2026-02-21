part of 'counter_bloc.dart';


@immutable
sealed class CounterBlocState extends Equatable {
  final int counter;

  const CounterBlocState({required this.counter});
  @override
  List<Object?> get props => [counter];
}

class CounterInit extends CounterBlocState {
  const CounterInit() : super(counter: 0);
}

class CounterUpdate extends CounterBlocState {
  const CounterUpdate({required super.counter});
}
