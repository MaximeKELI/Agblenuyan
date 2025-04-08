import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cartographie des Champs"),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.layers), onPressed: () {})],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 100, color: AppColors.primary),
            SizedBox(height: 20),
            Text(
              "Fonctionnalité en Développement",
              style: AppTextStyles.subtitle,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text("Activer la Localisation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_location),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
