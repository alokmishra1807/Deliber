import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliber/features/location/domain/usecase/get_location.dart';
import 'package:deliber/features/location/domain/usecase/get_address.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocationUsecase getLocationUsecase;
  final GetAddressUsecase getAddressUsecase;

  LocationBloc({
    required this.getLocationUsecase,
    required this.getAddressUsecase,
  }) : super(LocationInitial()) {
    on<RequestLocation>(_onRequestLocation);
  }

  Future<void> _onRequestLocation(
    RequestLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    final locationResult = await getLocationUsecase();

    await locationResult.fold(
      (failure) {
        emit(LocationFailure(failure.message));
      },
      (location) async {
        final addressResult = await getAddressUsecase(
          locationParams(lat: location.latitude, lng: location.longitude)
        );

        addressResult.fold(
          (failure) {
            emit(LocationFailure(failure.message));
          },
          (address) {
            emit(
              LocationLoaded(
                latitude: location.latitude,
                longitude: location.longitude,
                address: address,
              ),
            );
          },
        );
      },
    );
  }
}
