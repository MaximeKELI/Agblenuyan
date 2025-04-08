class Crop {
  final String name;
  final DateTime plantedDate;
  final double area;
  final String? type;

  Crop({
    required this.name,
    required this.plantedDate,
    required this.area,
    this.type,
  });

  get formattedDate => null;
  // ... autres méthodes
}
