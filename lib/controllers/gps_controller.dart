import 'package:geolocator/geolocator.dart';
import 'dart:async';

class GPSController {
  final _locationStreamController = StreamController<Position>.broadcast();
  Stream<Position> get locationStream => _locationStreamController.stream;

  double _totalDistance = 0.0;
  Position? _lastPosition;

  Future<void> start() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Serviço de localização desativado");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permissão de localização negada");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permissão negada permanentemente");
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, 
      ),
    ).listen((Position position) {
      if (_lastPosition != null) {
        _totalDistance += Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
      }
      _lastPosition = position;
      _locationStreamController.add(position);
    });
  }

  double get totalDistance => _totalDistance;

  void dispose() {
    _locationStreamController.close();
  }
}
