import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mode_selection_event.dart';
part 'mode_selection_state.dart';

class ModeSelectionBloc extends Bloc<ModeSelectionEvent, ModeSelectionState> {
  ModeSelectionBloc() : super(ModeSelectionInitial()) {
    on<ModeSelectionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
