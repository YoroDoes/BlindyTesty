part of 'spotify_auth_bloc.dart';

@immutable
abstract class SpotifyAuthEvent extends Equatable {
  const SpotifyAuthEvent();

  @override
  List<Object?> get props => [];
}

class SpotifyAuthenticate extends SpotifyAuthEvent {
  const SpotifyAuthenticate(this.status);

  final SpotifyAuthStatus status;

  @override
  List<Object?> get props => [status];
}

class SpotifyDisconnect extends SpotifyAuthEvent {
  const SpotifyDisconnect();

  final SpotifyAuthStatus status = SpotifyAuthStatus.disconnected;

  @override
  List<Object?> get props => [status];
}

class SpotifyConnect extends SpotifyAuthEvent {
  const SpotifyConnect();

  final SpotifyAuthStatus status = SpotifyAuthStatus.connected;

  @override
  List<Object?> get props => [status];
}
