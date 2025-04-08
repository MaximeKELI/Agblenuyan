import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final List<Map<String, dynamic>> _cropStats = [
    {"name": "Manioc", "yield": "12.5t/ha", "progress": 0.75},
    {"name": "Maïs", "yield": "8.2t/ha", "progress": 0.45},
    {"name": "Tomate", "yield": "5.7t/ha", "progress": 0.68},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistiques Agricoles"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryCard(),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _cropStats.length,
                itemBuilder:
                    (context, index) => _buildStatItem(_cropStats[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Rendement Moyen", style: AppTextStyles.title),
            SizedBox(height: 10),
            Text(
              "8.8 tonnes/ha",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(stat["name"]),
        subtitle: LinearProgressIndicator(
          value: stat["progress"],
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        trailing: Text(stat["yield"]),
      ),
    );
  }
}
