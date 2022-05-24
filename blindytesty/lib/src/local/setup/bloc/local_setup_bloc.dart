import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'local_setup_event.dart';
part 'local_setup_state.dart';

class LocalSetupBloc extends Bloc<LocalSetupEvent, LocalSetupState> {
  LocalSetupBloc() : super(const LocalSetupState()) {
    on<ChangeFields>(_onChangeFields);
  }

  Future<void> _onChangeFields(
      ChangeFields event, Emitter<LocalSetupState> emit) async {
    List<String> fields = RegExp(r'<(?<FieldName>\w+)>')
        .allMatches(event.text)
        .map((e) => e.namedGroup('FieldName') ?? '')
        .toList();
    RegExp fieldsRegexp =
        RegExp('^${event.text.replaceAll(RegExp(r'<\w+>'), '(.+)')}\$');
    emit(LocalSetupState.fromState(
      state,
      fields: fields,
      fieldsRegexp: fieldsRegexp,
    ));
  }
}
