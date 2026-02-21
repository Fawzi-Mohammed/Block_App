
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
