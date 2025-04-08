import 'package:flutter/material.dart';
import 'package:agblenuyan/data/models/field.dart';

class FieldInfoCard extends StatelessWidget {
  final Field field;
  final VoidCallback onClose;

  const FieldInfoCard({required this.field, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: Icon(Icons.close), onPressed: onClose),
              ],
            ),
            SizedBox(height: 8),
            Text('Culture: ${field.cropType}'),
            Text('Superficie: ${field.area} hectares'),
            Text('Planté le: ${_formatDate(field.plantedDate)}'),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: Text('Voir les détails')),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
