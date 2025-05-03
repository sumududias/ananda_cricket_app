import 'package:flutter/material.dart';
import '../../../../data/models/tournament.dart';
import '../../../../data/services/tournament_service.dart';
import '../../../../presentation/widgets/loading_indicator.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({Key? key}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  final TournamentService _tournamentService = TournamentService();
  List<Tournament> _tournaments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    try {
      final tournaments = await _tournamentService.getTournaments();
      setState(() {
        _tournaments = tournaments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tournaments: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add tournament functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : RefreshIndicator(
              onRefresh: _loadTournaments,
              child: ListView.builder(
                itemCount: _tournaments.length,
                itemBuilder: (context, index) {
                  final tournament = _tournaments[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        tournament.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Season: ${tournament.season}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tournament.dateRange,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Organizer: ${tournament.organizer}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (tournament.winnerTeam != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Winner: Team ${tournament.winnerTeam}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.green),
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            tournament.status,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getStatusColor(tournament),
                                    ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Navigate to tournament details
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  Color _getStatusColor(Tournament tournament) {
    if (tournament.isCompleted) return Colors.green;
    if (tournament.isActive) return Colors.blue;
    return Colors.orange;
  }
}
