part of 'location_bloc.dart';



@immutable
sealed class LocationEvent {}

class RequestLocation extends LocationEvent {}
