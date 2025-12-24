import 'package:geocoding/geocoding.dart';

abstract class GeocodingRemoteDataSource {
  Future<String> getAddressFromLatLng(double lat, double lng);
}

class GeocodingRemoteDataSourceImpl
    implements GeocodingRemoteDataSource {
  @override
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isEmpty) {
      return "Unknown location";
    }

    final place = placemarks.first;

    return [
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.country,
    ]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
  }
}
