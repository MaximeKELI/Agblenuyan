import 'package:latlong2/latlong.dart';

class Field {
  final String id;
  final String name;
  final LatLng coordinates;
  final double area;
  final String cropType;
  final DateTime plantedDate;

  Field({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.area,
    required this.cropType,
    required this.plantedDate,
  });
}
