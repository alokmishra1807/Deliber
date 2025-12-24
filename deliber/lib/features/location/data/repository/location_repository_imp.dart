import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/location/data/datasources/geo_coding_remote_datasource.dart';
import 'package:deliber/features/location/data/datasources/location_local_datasource.dart';
import 'package:deliber/features/location/domain/entity/location_entity.dart';
import 'package:deliber/features/location/domain/repositories/location_repository.dart';
import 'package:fpdart/fpdart.dart';

class LocationRepositoryImp implements LocationRepository {
  final GeocodingRemoteDataSource geocodingRemoteDataSource;
  final LocationLocalDataSource locationLocalDataSource;

  LocationRepositoryImp(
    this.geocodingRemoteDataSource,
    this.locationLocalDataSource,
  );

  @override
  Future<Either<Failure, String>> getCurrentAddress({
    required double lat,
    required double lng,
  }) async {
    try {
      final address = await geocodingRemoteDataSource.getAddressFromLatLng(
        lat,
        lng,
      );
      return Right(address);
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final locationModel = await locationLocalDataSource.getCurrentLocation();

      final locationEntity = LocationEntity(
        latitude: locationModel.latitude,
        longitude: locationModel.longitude,
      );

      return Right(locationEntity);
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }
}
