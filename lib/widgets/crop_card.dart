import 'package:flutter/material.dart';
import 'package:agblenuyan/data/models/crop.dart';

class CropCard extends StatelessWidget {
  final Crop crop;

  const CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(crop.name),
        subtitle: Text("Planté le ${crop.formattedDate}"),
        trailing: Text("${crop.area} ha"),
        leading: Icon(Icons.eco, color: Colors.green),
      ),
    );
  }
}
