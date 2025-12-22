import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/location/domain/entity/location_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class LocationRepository {
  Future<Either<Failure,LocationEntity>> getCurrentLocation();
  Future<Either<Failure,String>> getCurrentAddress({required double lat, required double lng});
}
