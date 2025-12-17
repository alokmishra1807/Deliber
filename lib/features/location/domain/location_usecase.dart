import 'package:location/location.dart';
import '../data/location_service.dart';

class RequestLocationUseCase {
  final LocationService locationService;

  RequestLocationUseCase(this.locationService);

  Future<LocationData?> call() {
    return locationService.requestLocation();
  }
}
