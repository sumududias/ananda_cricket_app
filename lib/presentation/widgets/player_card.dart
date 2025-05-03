import 'package:flutter/material.dart';
import '../../data/models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;

  const PlayerCard({
    super.key,
    required this.player,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildPlayerAvatar(context),
              const SizedBox(width: 16),
              Expanded(child: _buildPlayerDetails(context)),
              _buildRoleIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: _getPlayerImage(),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Failed to load player image: $exception');
      },
      child: _buildAvatarFallback(),
    );
  }

  ImageProvider _getPlayerImage() {
    if (player.photo.isEmpty) {
      return const AssetImage('assets/default_avatar.png');
    }
    return NetworkImage(player.photo);
  }

  Widget? _buildAvatarFallback() {
    if (player.photo.isEmpty) {
      return const Icon(Icons.person, size: 30);
    }
    return null;
  }

  Widget _buildPlayerDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${player.firstName} ${player.lastName}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Class ${player.playerClass} • ${player.yearJoined}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        if (player.battingStyle.isNotEmpty || player.bowlingStyle.isNotEmpty)
          Wrap(
            spacing: 8,
            children: [
              if (player.battingStyle.isNotEmpty)
                Chip(
                  label: Text(player.battingStyle),
                  visualDensity: VisualDensity.compact,
                ),
              if (player.bowlingStyle.isNotEmpty)
                Chip(
                  label: Text(player.bowlingStyle),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildRoleIndicator() {
    final roleColors = {
      'BAT': Colors.green,
      'BOWL': Colors.blue,
      'AR': Colors.orange,
      'WK': Colors.purple,
    };

    final color = roleColors[player.primaryRole] ?? Colors.grey;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        player.primaryRole,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}