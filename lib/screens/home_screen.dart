import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocimetro_flutter/controllers/gps_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GPSController _gpsController = GPSController();
  double _speed = 0.0;
  double _distance = 0.0;
  String _lastUpdate = "Sem dados";

  @override
  void initState() {
    super.initState();
    _startGPS();
  }

  Future<void> _startGPS() async {
    try {
      await _gpsController.start();
      _gpsController.locationStream.listen((Position position) {
        setState(() {
          _speed = position.speed * 3.6; // m/s → km/h
          _distance = _gpsController.totalDistance;
          _lastUpdate = DateFormat("HH:mm:ss").format(DateTime.now());
        });
      });
    } catch (e) {
      setState(() {
        _lastUpdate = "Erro: $e";
      });
    }
  }

  @override
  void dispose() {
    _gpsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Velocímetro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Velocidade: ${_speed.toStringAsFixed(2)} km/h",
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text("Distância: ${_distance.toStringAsFixed(2)} m",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text("Última atualização: $_lastUpdate"),
          ],
        ),
      ),
    );
  }
}
