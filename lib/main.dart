import 'package:flutter/material.dart';
import 'core/config/theme_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/players/presentation/pages/matches_screen.dart';
import 'features/players/presentation/pages/players_screen.dart';
import 'features/players/presentation/pages/teams_screen.dart';
import 'features/players/presentation/pages/tournaments_screen.dart';
import 'presentation/screens/placeholder_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Ananda Cricket',
        theme: AppTheme.theme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/players': (context) => const PlaceholderScreen(title: 'Players'),
          '/teams': (context) => const PlaceholderScreen(title: 'Teams'),
          '/matches': (context) => const PlaceholderScreen(title: 'Matches'),
          '/statistics': (context) =>
              const PlaceholderScreen(title: 'Statistics'),
          '/tournaments': (context) =>
              const PlaceholderScreen(title: 'Tournaments'),
          '/news': (context) => const PlaceholderScreen(title: 'News'),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TournamentsScreen(),
    MatchesScreen(),
    TeamsScreen(),
    PlayersScreen(),
  ];

  final List<String> _titles = [
    'Tournaments',
    'Matches',
    'Teams',
    'Players',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Tournaments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Players',
          ),
        ],
      ),
    );
  }
}
