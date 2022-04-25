part of 'platform_bloc.dart';

@immutable
class PlatformState extends Equatable {
  final String? platform;

  const PlatformState._({this.platform});

  const PlatformState.unknown() : this._();
  const PlatformState.local() : this._(platform: 'local');
  const PlatformState.spotify() : this._(platform: 'spotify');
  const PlatformState.youtube() : this._(platform: 'youtube');

  const PlatformState.fromString(this.platform);

  @override
  List<Object?> get props => [platform];
}
