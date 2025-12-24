import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/location/domain/entity/location_entity.dart';
import 'package:deliber/features/location/domain/repositories/location_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLocationUsecase {
  final LocationRepository locationRepository;

  GetLocationUsecase(this.locationRepository);

  Future<Either<Failure,LocationEntity>>call() {
    return locationRepository.getCurrentLocation();
  }
}
