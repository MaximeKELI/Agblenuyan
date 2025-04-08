import 'package:flutter/material.dart';
import 'package:agblenuyan/core/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paramètres"), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Préférences"),
          SwitchListTile(
            title: Text("Notifications"),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: Text("Mode Sombre"),
            value: _darkModeEnabled,
            onChanged: (value) => setState(() => _darkModeEnabled = value),
            activeColor: AppColors.primary,
          ),
          Divider(),
          _buildSectionHeader("Compte"),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Modifier le Profil"),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Changer le Mot de Passe"),
            onTap: () {},
          ),
          Divider(),
          _buildSectionHeader("Application"),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Aide"),
            onTap: () => Navigator.pushNamed(context, '/help'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("À Propos"),
            onTap: () {},
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              child: Text("Déconnexion"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Déconnexion"),
            content: Text("Voulez-vous vraiment vous déconnecter ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text("Déconnexion", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
