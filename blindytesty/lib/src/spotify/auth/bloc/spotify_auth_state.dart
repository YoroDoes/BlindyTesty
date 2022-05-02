part of 'spotify_auth_bloc.dart';

enum SpotifyAuthStatus {
  unknown,
  connected,
  connecting,
  disconnected,
}

@immutable
class SpotifyAuthState extends Equatable {
  final SpotifyAuthStatus? status;

  const SpotifyAuthState._({this.status});

  const SpotifyAuthState({required this.status});
  const SpotifyAuthState.unknown() : this._(status: SpotifyAuthStatus.unknown);
  const SpotifyAuthState.connected()
      : this._(status: SpotifyAuthStatus.connected);
  const SpotifyAuthState.connecting()
      : this._(status: SpotifyAuthStatus.connecting);
  const SpotifyAuthState.disconnected()
      : this._(status: SpotifyAuthStatus.disconnected);

  @override
  List<Object?> get props => [status];
}
