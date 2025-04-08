import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Profil"),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.edit), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            SizedBox(height: 20),
            Text("Agriculteur", style: AppTextStyles.title),
            Text("Membre depuis 2023", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),
            _buildInfoCard(),
            SizedBox(height: 20),
            _buildDetailItem(Icons.location_on, "Niamey, Niger"),
            _buildDetailItem(Icons.phone, "+227 90 00 00 00"),
            _buildDetailItem(Icons.email, "agriculteur@example.com"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Modifier le Profil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem("5", "Champs"),
            _buildStatItem("3", "Cultures"),
            _buildStatItem("12", "Mois"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
