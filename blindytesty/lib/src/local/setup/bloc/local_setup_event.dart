part of 'local_setup_bloc.dart';

abstract class LocalSetupEvent extends Equatable {
  const LocalSetupEvent();

  @override
  List<Object> get props => [];
}

class ChangeFields extends LocalSetupEvent {
  const ChangeFields({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}
