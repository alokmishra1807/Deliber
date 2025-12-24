part of 'location_bloc.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  final String address;

  LocationLoaded({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationFailure extends LocationState {
  final String message;

  LocationFailure(this.message);
}
