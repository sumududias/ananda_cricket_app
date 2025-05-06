import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/config/api_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isTestingApi = false;
  String _apiStatus = '';

  Future<void> _testApiConnection() async {
    setState(() {
      _isTestingApi = true;
      _apiStatus = 'Testing API connection...';
    });

    try {
      final isConnected = await ApiConfig.testConnection();
      setState(() {
        _apiStatus = isConnected
            ? 'API connection successful!'
            : 'API connection failed. Check your network or server.';
      });
    } catch (e) {
      setState(() {
        _apiStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isTestingApi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ananda Cricket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.network_check),
            onPressed: _isTestingApi ? null : _testApiConnection,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_apiStatus.isNotEmpty)
            Container(
              color: _apiStatus.contains('successful')
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    _apiStatus.contains('successful')
                        ? Icons.check_circle
                        : Icons.error,
                    color: _apiStatus.contains('successful')
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _apiStatus,
                      style: TextStyle(
                        color: _apiStatus.contains('successful')
                            ? Colors.green.shade900
                            : Colors.red.shade900,
                      ),
                    ),
                  ),
                  if (_apiStatus.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _apiStatus = ''),
                      color: Colors.grey,
                    ),
                ],
              ),
            ),
          Expanded(
            child: GridView.count(
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
