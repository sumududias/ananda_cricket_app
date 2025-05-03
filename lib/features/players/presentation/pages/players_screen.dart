import 'package:flutter/material.dart';
import '../../../../data/models/player.dart';
import '../../../../data/services/api_service.dart';
import '../../../../core/config/api_config.dart';

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
              final player = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: player.photo != null
                        ? NetworkImage(
                            player.photo!,
                            headers: {'Accept': 'image/*'},
                          )
                        : null,
                    child:
                        player.photo == null ? const Icon(Icons.person) : null,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('DEBUG: Error loading image: $exception');
                      print('DEBUG: Image URL was: ${player.photo}');
                    },
                  ),
                  title: Text(player.fullName),
                  subtitle: Text(
                    [
                      if (player.primaryRole != null) player.primaryRole,
                      if (player.playerClass != null)
                        'Class ${player.playerClass}',
                    ].join(' - '),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (player.battingStats != null) ...[
                        Text(
                          'Matches: ${player.battingStats!.matches}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Runs: ${player.battingStats!.runs}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      if (player.bowlingStats != null &&
                          player.bowlingStats!.wickets > 0)
                        Text(
                          'Wickets: ${player.bowlingStats!.wickets}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                  onTap: () => _navigateToPlayerDetails(player),
                ),
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
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoSection('Personal Information', [
                        _buildInfoRow('Date of Birth',
                            '${player.dob.day}/${player.dob.month}/${player.dob.year}'),
                        if (player.battingStyle != null)
                          _buildInfoRow('Batting Style', player.battingStyle!),
                        if (player.bowlingStyle != null)
                          _buildInfoRow('Bowling Style', player.bowlingStyle!),
                        if (player.yearJoined != null)
                          _buildInfoRow(
                              'Year Joined', player.yearJoined.toString()),
                      ]),
                      const SizedBox(height: 24),
                      if (player.battingStats != null) ...[
                        _buildInfoSection('Batting Statistics', [
                          _buildInfoRow('Matches',
                              player.battingStats!.matches.toString()),
                          _buildInfoRow('Innings',
                              player.battingStats!.innings.toString()),
                          _buildInfoRow('Not Outs',
                              player.battingStats!.notOuts.toString()),
                          _buildInfoRow(
                              'Runs', player.battingStats!.runs.toString()),
                          _buildInfoRow('Balls Faced',
                              player.battingStats!.ballsFaced.toString()),
                          _buildInfoRow('Average',
                              player.battingStats!.average.toStringAsFixed(2)),
                          _buildInfoRow(
                              'Strike Rate',
                              player.battingStats!.strikeRate
                                  .toStringAsFixed(2)),
                          _buildInfoRow('Highest Score',
                              player.battingStats!.highestScore.toString()),
                          _buildInfoRow(
                              'Fours', player.battingStats!.fours.toString()),
                          _buildInfoRow(
                              'Sixes', player.battingStats!.sixes.toString()),
                        ]),
                        const SizedBox(height: 24),
                      ],
                      if (player.bowlingStats != null) ...[
                        _buildInfoSection('Bowling Statistics', [
                          _buildInfoRow('Matches',
                              player.bowlingStats!.matches.toString()),
                          _buildInfoRow('Innings',
                              player.bowlingStats!.innings.toString()),
                          _buildInfoRow(
                              'Overs', player.bowlingStats!.overs.toString()),
                          _buildInfoRow(
                              'Runs', player.bowlingStats!.runs.toString()),
                          _buildInfoRow('Wickets',
                              player.bowlingStats!.wickets.toString()),
                          _buildInfoRow('Average',
                              player.bowlingStats!.average.toStringAsFixed(2)),
                          _buildInfoRow('Economy',
                              player.bowlingStats!.economy.toStringAsFixed(2)),
                          _buildInfoRow(
                              'Strike Rate',
                              player.bowlingStats!.strikeRate
                                  .toStringAsFixed(2)),
                          _buildInfoRow(
                              'Best Bowling', player.bowlingStats!.bestBowling),
                        ]),
                        const SizedBox(height: 24),
                      ],
                      if (player.fieldingStats != null) ...[
                        _buildInfoSection('Fielding Statistics', [
                          _buildInfoRow('Matches',
                              player.fieldingStats!.matches.toString()),
                          _buildInfoRow('Catches',
                              player.fieldingStats!.catches.toString()),
                          _buildInfoRow('Stumpings',
                              player.fieldingStats!.stumpings.toString()),
                          _buildInfoRow('Run Outs',
                              player.fieldingStats!.runouts.toString()),
                        ]),
                      ],
                    ],
                  ),
                ),
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
            '${player.primaryRole ?? 'Player'} • Class ${player.playerClass ?? 'N/A'}',
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

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
