import 'package:deliber/features/location/data/model/location_model.dart';
import 'package:location/location.dart';

abstract class LocationLocalDataSource {
  Future<LocationModel> getCurrentLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final Location location;

  LocationLocalDataSourceImpl(this.location);

  @override
  Future<LocationModel> getCurrentLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception("Location service disabled");
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception("Location permission denied");
      }
    }

    final data = await location.getLocation();

    return LocationModel(
      latitude: data.latitude!,
      longitude: data.longitude!,
    );
  }
}
