import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ananda Cricket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeatureCard(
            context,
            'Players',
            Icons.people,
            '/players',
          ),
          _buildFeatureCard(
            context,
            'Teams',
            Icons.groups,
            '/teams',
          ),
          _buildFeatureCard(
            context,
            'Matches',
            Icons.sports_cricket,
            '/matches',
          ),
          _buildFeatureCard(
            context,
            'Statistics',
            Icons.bar_chart,
            '/statistics',
          ),
          _buildFeatureCard(
            context,
            'Tournaments',
            Icons.emoji_events,
            '/tournaments',
          ),
          _buildFeatureCard(
            context,
            'News',
            Icons.newspaper,
            '/news',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
} 