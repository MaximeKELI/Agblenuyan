import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class HelpScreen extends StatelessWidget {
  final List<Map<String, String>> _faqs = [
    {
      "question": "Comment diagnostiquer une maladie ?",
      "answer":
          "Utilisez l'appareil photo pour scanner les feuilles de vos plantes.",
    },
    {
      "question": "Comment ajouter une nouvelle culture ?",
      "answer": "Allez dans 'Mes Cultures' et cliquez sur le bouton '+'.",
    },
    {
      "question": "Les données sont-elles synchronisées ?",
      "answer": "Oui, vos données sont sauvegardées sur le cloud.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aide & FAQ"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Questions Fréquentes", style: AppTextStyles.title),
            SizedBox(height: 20),
            ..._faqs.map((faq) => _buildFaqItem(faq)).toList(),
            SizedBox(height: 30),
            _buildContactCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq["question"]!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(padding: EdgeInsets.all(16), child: Text(faq["answer"]!)),
      ],
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Besoin d'aide supplémentaire ?",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text("Contactez notre équipe :"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text("Envoyer un Message"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
