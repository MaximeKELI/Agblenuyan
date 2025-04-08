import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class AdviceScreen extends StatelessWidget {
  final Map<String, String> _adviceData = {
    "Manioc": "Arrosez modérément et évitez les sols gorgés d'eau.",
    "Maïs": "Appliquez de l'engrais azoté 3 semaines après la plantation.",
    "Tomate": "Paillez pour conserver l'humidité du sol.",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conseils Agricoles")),
      body: ListView(
        children:
            _adviceData.entries
                .map(
                  (entry) => AdviceTile(crop: entry.key, advice: entry.value),
                )
                .toList(),
      ),
    );
  }
}

class AdviceTile extends StatelessWidget {
  final String crop;
  final String advice;

  const AdviceTile({required this.crop, required this.advice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(crop),
        subtitle: Text(advice),
        leading: Icon(Icons.agriculture),
      ),
    );
  }
}
