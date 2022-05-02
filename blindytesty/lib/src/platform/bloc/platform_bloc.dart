import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:blindytesty/src/services/models/models.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  PlatformBloc() : super(const PlatformState.unknown()) {
    on<PlatformChanged>(_onPlatformChanged);
    on<PlatformUnset>(_onPlatformUnset);
    on<PlatformConnectedFromCallback>(_onPlatformConnectedFromCallback);
  }

  void _onPlatformChanged(
    PlatformChanged event,
    Emitter<PlatformState> emit,
  ) {
    SettingsObject settings = Storage.getSettings();
    settings.selectedPlatform = event.platform;
    Storage.setSettings(settings);
    emit(PlatformState.fromString(event.platform));
  }

  void _onPlatformConnectedFromCallback(
    PlatformConnectedFromCallback event,
    Emitter<PlatformState> emit,
  ) {
    emit(PlatformState.connectionCallback(
        connectionCallback: event.connectionCallback,
        platform: event.platform));
  }

  void _onPlatformUnset(
    PlatformEvent event,
    Emitter<PlatformState> emit,
  ) {
    SettingsObject settings = Storage.getSettings();
    settings.selectedPlatform = null;
    Storage.setSettings(settings);
    emit(const PlatformState.unknown());
  }
}
