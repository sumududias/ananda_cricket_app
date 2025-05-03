import 'package:flutter/material.dart';
import '../../../../core/services/team_service.dart';
import '../../../../data/models/team.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final TeamService _teamService = TeamService();
  List<Team>? _teams;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final teams = await _teamService.getTeams();
      setState(() {
        _teams = teams;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add team functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadTeams,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_teams == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_teams!.isEmpty) {
      return const Center(child: Text('No teams found'));
    }

    return RefreshIndicator(
      onRefresh: _loadTeams,
      child: ListView.builder(
        itemCount: _teams!.length,
        itemBuilder: (context, index) {
          final team = _teams![index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: team.logo != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(team.logo!),
                      onBackgroundImageError: (_, __) {
                        // Handle image load error
                      },
                    )
                  : CircleAvatar(
                      child: Text(team.name[0].toUpperCase()),
                    ),
              title: Text(team.name),
              subtitle: team.description != null
                  ? Text(
                      team.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: team.isActive
                  ? Icon(Icons.check_circle, color: Colors.green[700])
                  : const Icon(Icons.cancel, color: Colors.red),
              onTap: () {
                // TODO: Navigate to team details
              },
            ),
          );
        },
      ),
    );
  }
}
