import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa de Geolocalização',
      home: MapaScreen(),
    );
  }
}

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Stream<Position> _stream = Geolocator.getPositionStream();
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Localização no Mapa'),
      ),
      body: StreamBuilder<Position>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final positionData = snapshot.data;
          if (positionData == null) {
            return const Center(child: Text('Erro ao obter localização.'));
          }

          final latLng =
              LatLng(positionData.latitude, positionData.longitude);

          _mapController?.animateCamera(
            CameraUpdate.newLatLng(latLng),
          );

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: latLng,
              zoom: 17,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId('minhaPosicao'),
                position: latLng,
                infoWindow: InfoWindow(
                  title: 'Estou Aqui!',
                  snippet:
                      'Lat: ${positionData.latitude.toStringAsFixed(5)}, Lon: ${positionData.longitude.toStringAsFixed(5)}',
                ),
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }
}