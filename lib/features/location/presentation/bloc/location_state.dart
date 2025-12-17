part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

class LocationGranted extends LocationState {
  final LocationData location;
  LocationGranted(this.location);
}

class LocationDenied extends LocationState {}

class LocationFailure extends LocationState {
  final String message;
  LocationFailure(this.message);
}
