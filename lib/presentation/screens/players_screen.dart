import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../../data/models/player.dart';
import '../widgets/player_card.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late Future<List<Player>> _playersFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      _playersFuture = ApiService().fetchPlayers();
      await _playersFuture;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToPlayerDetails(Player player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerDetailsScreen(player: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ananda College Players'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadPlayers,
            ),
        ],
      ),
      body: FutureBuilder<List<Player>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load players'),
                  Text(snapshot.error.toString()),
                  ElevatedButton(
                    onPressed: _loadPlayers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No players found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PlayerCard(
                player: snapshot.data![index],
                onTap: () => _navigateToPlayerDetails(snapshot.data![index]),
              );
            },
          );
        },
      ),
    );
  }
}

class PlayerDetailsScreen extends StatefulWidget {
  final Player player;

  const PlayerDetailsScreen({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  late Future<Player> _playerFuture;

  @override
  void initState() {
    super.initState();
    _loadPlayerDetails();
  }

  void _loadPlayerDetails() {
    _playerFuture = ApiService().fetchPlayerDetails(widget.player.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadPlayerDetails();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Player>(
        future: _playerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load player details'),
                  Text(snapshot.error.toString()),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadPlayerDetails();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final player = snapshot.data ?? widget.player;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, player),
                _buildStats(context, player),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Player player) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                player.photo != null ? NetworkImage(player.photo!) : null,
            child: player.photo == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            player.fullName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '${player.primaryRole} • Class ${player.playerClass}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (player.battingStyle != null || player.bowlingStyle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                [
                  if (player.battingStyle != null) player.battingStyle,
                  if (player.bowlingStyle != null) player.bowlingStyle,
                ].where((s) => s != null).join(' • '),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, Player player) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (player.battingStats != null) ...[
            _buildSectionTitle(context, 'Batting Statistics'),
            _buildBattingStats(context, player.battingStats!),
            const SizedBox(height: 24),
          ],
          if (player.bowlingStats != null) ...[
            _buildSectionTitle(context, 'Bowling Statistics'),
            _buildBowlingStats(context, player.bowlingStats!),
            const SizedBox(height: 24),
          ],
          if (player.fieldingStats != null) ...[
            _buildSectionTitle(context, 'Fielding Statistics'),
            _buildFieldingStats(context, player.fieldingStats!),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildBattingStats(BuildContext context, BattingStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Matches', stats.matches.toString()),
            _buildStatRow('Innings', stats.innings.toString()),
            _buildStatRow('Not Outs', stats.notOuts.toString()),
            _buildStatRow('Runs', stats.runs.toString()),
            _buildStatRow('Balls Faced', stats.ballsFaced.toString()),
            _buildStatRow('Average', stats.average.toStringAsFixed(2)),
            _buildStatRow('Strike Rate', stats.strikeRate.toStringAsFixed(2)),
            _buildStatRow('Highest Score', stats.highestScore.toString()),
            _buildStatRow('Fours', stats.fours.toString()),
            _buildStatRow('Sixes', stats.sixes.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildBowlingStats(BuildContext context, BowlingStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Matches', stats.matches.toString()),
            _buildStatRow('Innings', stats.innings.toString()),
            _buildStatRow('Overs', stats.overs.toString()),
            _buildStatRow('Runs', stats.runs.toString()),
            _buildStatRow('Wickets', stats.wickets.toString()),
            _buildStatRow('Average', stats.average.toStringAsFixed(2)),
            _buildStatRow('Economy', stats.economy.toStringAsFixed(2)),
            _buildStatRow('Strike Rate', stats.strikeRate.toStringAsFixed(2)),
            _buildStatRow('Best Bowling', stats.bestBowling),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldingStats(BuildContext context, FieldingStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Matches', stats.matches.toString()),
            _buildStatRow('Catches', stats.catches.toString()),
            _buildStatRow('Stumpings', stats.stumpings.toString()),
            _buildStatRow('Run Outs', stats.runouts.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
