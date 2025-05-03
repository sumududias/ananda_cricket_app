import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/match.dart';
import '../../../../data/services/match_service.dart';
import '../../../../presentation/widgets/loading_indicator.dart';

class MatchDetailsScreen extends StatefulWidget {
  final Match match;

  const MatchDetailsScreen({Key? key, required this.match}) : super(key: key);

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  final MatchService _matchService = MatchService();
  bool _isLoading = true;
  late Match _match;

  @override
  void initState() {
    super.initState();
    _match = widget.match;
    _loadMatchDetails();
  }

  Future<void> _loadMatchDetails() async {
    try {
      final match = await _matchService.getMatch(_match.id);
      print('DEBUG: Loaded match details:');
      print('Match ID: ${match.id}');
      print('Players count: ${match.players?.length ?? 0}');
      if (match.players != null) {
        for (var player in match.players!) {
          print('Player: ${player.playerName} (ID: ${player.player})');
          print(
              '  Batting: ${player.runsScored} runs from ${player.ballsFaced} balls');
          print(
              '  Bowling: ${player.wicketsTaken} wickets for ${player.runsConceded} runs');
        }
      }
      setState(() {
        _match = match;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Error loading match details: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading match details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMatchHeader(),
                  const SizedBox(height: 16),
                  _buildMatchInfo(),
                  const SizedBox(height: 16),
                  _buildTossInfo(),
                  const SizedBox(height: 16),
                  _buildScorecard(),
                  if (_match.players != null && _match.players!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildBattingScorecard(),
                    const SizedBox(height: 24),
                    _buildBowlingScorecard(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildMatchHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ananda College vs ${_match.opponent}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM d, y').format(_match.matchDate),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_match.venue != null) _buildInfoRow('Venue', _match.venue!),
            if (_match.matchType != null)
              _buildInfoRow('Match Type', _match.matchType!),
            if (_match.tournament != null)
              _buildInfoRow('Tournament',
                  _match.tournamentName ?? _match.tournament.toString()),
            if (_match.result != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Result', _match.result!),
              _buildInfoRow(
                  'Ananda Score', _match.anandaScore ?? 'Not available'),
              _buildInfoRow(
                  'Opponent Score', _match.opponentScore ?? 'Not available'),
            ],
            if (_match.manOfMatch != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Man of the Match', _match.manOfMatchName ?? ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTossInfo() {
    if (_match.tossWinner == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toss Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Won by', _match.tossWinner!),
            if (_match.tossDecision != null)
              _buildInfoRow('Elected to', _match.tossDecision!),
          ],
        ),
      ),
    );
  }

  Widget _buildScorecard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Result',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_match.anandaScore != null)
              _buildInfoRow('Ananda College', _match.anandaScore!),
            if (_match.opponentScore != null)
              _buildInfoRow(_match.opponent, _match.opponentScore!),
            if (_match.result != null) ...[
              const SizedBox(height: 8),
              Text(
                _match.result!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _match.result!.toLowerCase().contains('won')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBattingScorecard() {
    final battingPlayers = _match.players
            ?.where((p) => p.battingOrder != null)
            .toList()
            .cast<MatchPlayer>() ??
        [];
    battingPlayers.sort((a, b) => a.battingOrder!.compareTo(b.battingOrder!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batting Scorecard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Batter')),
                  DataColumn(label: Text('R'), numeric: true),
                  DataColumn(label: Text('B'), numeric: true),
                  DataColumn(label: Text('4s'), numeric: true),
                  DataColumn(label: Text('6s'), numeric: true),
                  DataColumn(label: Text('SR'), numeric: true),
                  DataColumn(label: Text('How Out')),
                ],
                rows: battingPlayers.map((player) {
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(player.playerName ?? 'Player ${player.player}')),
                      DataCell(Text(player.runsScored.toString())),
                      DataCell(Text(player.ballsFaced.toString())),
                      DataCell(Text(player.fours.toString())),
                      DataCell(Text(player.sixes.toString())),
                      DataCell(Text(player.strikeRate.toStringAsFixed(2))),
                      DataCell(Text(player.howOut ?? 'Not Out')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBowlingScorecard() {
    final bowlingPlayers = _match.players
            ?.where((p) => p.oversBowled > 0)
            .toList()
            .cast<MatchPlayer>() ??
        [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bowling Scorecard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Bowler')),
                  DataColumn(label: Text('O'), numeric: true),
                  DataColumn(label: Text('R'), numeric: true),
                  DataColumn(label: Text('W'), numeric: true),
                  DataColumn(label: Text('Econ'), numeric: true),
                ],
                rows: bowlingPlayers.map((player) {
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(player.playerName ?? 'Player ${player.player}')),
                      DataCell(Text(player.oversBowled.toString())),
                      DataCell(Text(player.runsConceded.toString())),
                      DataCell(Text(player.wicketsTaken.toString())),
                      DataCell(Text(player.bowlingEconomy.toStringAsFixed(2))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
