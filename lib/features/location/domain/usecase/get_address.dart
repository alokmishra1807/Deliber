// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/location/domain/repositories/location_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAddressUsecase {
  final LocationRepository locationRepository;

  GetAddressUsecase(this.locationRepository);

  Future<Either<Failure, String>> call(locationParams params) {
    return locationRepository.getCurrentAddress(
      lat: params.lat,
      lng: params.lng
    );
  }
}

class locationParams {
  double lat;
  double lng;
  locationParams({
    required this.lat,
    required this.lng,
  });
  
}
