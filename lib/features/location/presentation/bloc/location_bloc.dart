import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import 'package:deliber/features/location/domain/location_usecase.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final RequestLocationUseCase _requestLocationUseCase;

  LocationBloc(this._requestLocationUseCase)
      : super(LocationInitial()) {
    on<RequestLocation>(_onRequestLocation);
  }

  Future<void> _onRequestLocation(
    RequestLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    try {
      final LocationData? location =
          await _requestLocationUseCase();

      if (location == null) {
        emit(LocationDenied());
      } else {
        emit(LocationGranted(location));
      }
    } catch (e) {
      emit(LocationFailure(e.toString()));
    }
  }
}
