import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'counter_bloc_state.dart';
part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, CounterBlocState> {
  CounterBloc() : super(CounterInit()) {
    on<IncrementEvent>((event, emit) {
      emit(CounterUpdate(counter: state.counter + 1));
    });
    on<DecrementEvent>(
      (event, emit) => emit(CounterUpdate(counter: state.counter - 1)),
    );
  }
}
