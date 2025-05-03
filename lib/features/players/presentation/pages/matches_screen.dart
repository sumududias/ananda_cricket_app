import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/match.dart';
import '../../../../data/services/match_service.dart';
import '../../../../presentation/widgets/loading_indicator.dart';
import 'match_details_screen.dart'; // Since it's in the same directory

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final MatchService _matchService = MatchService();
  List<Match> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final matches = await _matchService.getMatches();
      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading matches: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add match functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : RefreshIndicator(
              onRefresh: _loadMatches,
              child: ListView.builder(
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final match = _matches[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Ananda College vs ${match.opponent}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMM yyyy').format(match.matchDate),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (match.venue != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Venue: ${match.venue}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            _getMatchStatus(match),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getStatusColor(match),
                                    ),
                          ),
                          if (match.anandaScore != null &&
                              match.opponentScore != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Score: ${match.anandaScore} vs ${match.opponentScore}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MatchDetailsScreen(match: match),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _getMatchStatus(Match match) {
    if (match.result != null) return match.result!;
    return 'Upcoming';
  }

  Color _getStatusColor(Match match) {
    if (match.result == null) return Colors.blue;
    if (match.result!.toLowerCase().contains('won')) return Colors.green;
    if (match.result!.toLowerCase().contains('lost')) return Colors.red;
    return Colors.orange;
  }
}
