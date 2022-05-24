part of 'local_setup_bloc.dart';

class LocalSetupState extends Equatable {
  const LocalSetupState({
    this.fields,
    this.fieldsRegexp,
  });
  LocalSetupState.fromState(
    LocalSetupState prevState, {
    fields,
    fieldsRegexp,
  })  : fields = prevState.fields ?? fields,
        fieldsRegexp = prevState.fieldsRegexp ?? fieldsRegexp;

  final List<String>? fields;
  final RegExp? fieldsRegexp;

  @override
  List<Object?> get props => [
        fields,
        fieldsRegexp,
      ];
}
