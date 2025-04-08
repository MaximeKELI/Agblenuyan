import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _historyItems = [
    {
      "date": "15/06/2024",
      "action": "Diagnostic Manioc",
      "result": "Mildiou détecté",
      "icon": Icons.camera_alt,
      "color": Colors.blue,
    },
    {
      "date": "10/06/2024",
      "action": "Plantation Maïs",
      "result": "0.5 ha plantés",
      "icon": Icons.eco,
      "color": Colors.green,
    },
    {
      "date": "05/06/2024",
      "action": "Consultation Conseil",
      "result": "Engrais recommandé",
      "icon": Icons.lightbulb_outline,
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique"), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _historyItems.length,
        itemBuilder:
            (context, index) => _buildHistoryItem(_historyItems[index]),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: item["color"].withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(item["icon"], color: item["color"]),
        ),
        title: Text(item["action"]),
        subtitle: Text(item["date"]),
        trailing: Text(
          item["result"],
          style: TextStyle(color: AppColors.primary),
        ),
        onTap: () {},
      ),
    );
  }
}
