import 'package:flutter/material.dart';
import 'package:agblenuyan/core/app_router.dart';
import 'package:agblenuyan/core/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agri Smart Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: _buildDrawer(context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  Icons.camera_alt,
                  'Diagnostiquer',
                  AppRouter.diagnosis,
                  Colors.blueAccent,
                ),
                _buildFeatureCard(
                  context,
                  Icons.eco,
                  'Mes Cultures',
                  AppRouter.crops,
                  Colors.green,
                ),
                _buildFeatureCard(
                  context,
                  Icons.lightbulb_outline,
                  'Conseils',
                  AppRouter.advice,
                  Colors.orange,
                ),
                _buildFeatureCard(
                  context,
                  Icons.analytics,
                  'Statistiques',
                  '/stats',
                  Colors.purple,
                ),
                _buildFeatureCard(
                  context,
                  Icons.map,
                  'Cartographie',
                  '/map',
                  Colors.teal,
                ),
                _buildFeatureCard(
                  context,
                  Icons.settings,
                  'Paramètres',
                  '/settings',
                  Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primaryLight],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Agriculteur',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            Icons.home,
            'Accueil',
            () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            Icons.person,
            'Profil',
            () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildDrawerItem(
            context,
            Icons.history,
            'Historique',
            () => Navigator.pushNamed(context, '/history'),
          ),
          Divider(),
          _buildDrawerItem(
            context,
            Icons.settings,
            'Paramètres',
            () => Navigator.pushNamed(context, '/settings'),
          ),
          _buildDrawerItem(
            context,
            Icons.help,
            'Aide',
            () => Navigator.pushNamed(context, '/help'),
          ),
          _buildDrawerItem(
            context,
            Icons.exit_to_app,
            'Déconnexion',
            () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryDark),
      title: Text(title),
      onTap: onTap,
      hoverColor: Colors.green[100],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    Color color,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Déconnexion'),
            content: Text('Voulez-vous vraiment vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Déconnexion', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
