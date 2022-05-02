part of 'platform_bloc.dart';

@immutable
abstract class PlatformEvent extends Equatable {
  const PlatformEvent();

  @override
  List<Object?> get props => [];
}

class PlatformChanged extends PlatformEvent {
  final String platform;

  const PlatformChanged(this.platform);

  @override
  List<Object?> get props => [platform];
}

class PlatformConnectedFromCallback extends PlatformEvent {
  final bool connectionCallback = true;
  final String? platform;

  const PlatformConnectedFromCallback({this.platform});

  @override
  List<Object?> get props => [connectionCallback, platform];
}

class PlatformUnset extends PlatformEvent {}
