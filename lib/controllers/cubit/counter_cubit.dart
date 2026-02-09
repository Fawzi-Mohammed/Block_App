import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInit());

  void increment() {
    emit(CounterUpdate(counter: state.counter + 1));
  }

  void decrement() {
    emit(CounterUpdate(counter: state.counter - 1));
  }
}
