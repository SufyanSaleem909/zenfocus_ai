import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MoodEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = StorageService.getMoodHistory();
    });
  }

  // Calculate averages
  double get _avgMood => _history.isEmpty
      ? 0
      : _history.map((e) => e.mood).reduce((a, b) => a + b) / _history.length;

  double get _avgEnergy => _history.isEmpty
      ? 0
      : _history.map((e) => e.energy).reduce((a, b) => a + b) / _history.length;

  double get _avgStress => _history.isEmpty
      ? 0
      : _history.map((e) => e.stress).reduce((a, b) => a + b) / _history.length;

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _history.isEmpty
            ? _buildEmptyState()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Summary Cards ─────────────────
                    Text(
                      'Your Averages',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildAverageCard(
                          context,
                          label: 'Mood',
                          value: _avgMood,
                          emoji: '😊',
                          color: AppTheme.accent,
                        ),
                        const SizedBox(width: 10),
                        _buildAverageCard(
                          context,
                          label: 'Energy',
                          value: _avgEnergy,
                          emoji: '⚡',
                          color: AppTheme.secondary,
                        ),
                        const SizedBox(width: 10),
                        _buildAverageCard(
                          context,
                          label: 'Stress',
                          value: _avgStress,
                          emoji: '🌊',
                          color: AppTheme.primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ─── Trend Bar ─────────────────────
                    if (_history.length >= 3) ...[
                      Text(
                        'Last 7 Days — Mood Trend',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildMoodTrendBar(),
                      const SizedBox(height: 28),
                    ],

                    // ─── History List ──────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Check-ins (${_history.length})',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._history.map((entry) => _buildEntryCard(entry)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAverageCard(
    BuildContext context, {
    required String label,
    required double value,
    required String emoji,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTrendBar() {
    final recent = _history.take(7).toList().reversed.toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: recent.map((entry) {
          final height = (entry.mood / 10) * 60;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${entry.mood}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 28,
                height: height.clamp(8.0, 60.0),
                decoration: BoxDecoration(
                  color: entry.mood >= 7
                      ? AppTheme.success
                      : entry.mood >= 4
                      ? AppTheme.warning
                      : AppTheme.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(entry.timestamp).substring(0, 3).toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEntryCard(MoodEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date + time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(entry.timestamp),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
              Text(
                _formatTime(entry.timestamp),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Stats row
          Row(
            children: [
              _buildStatChip('😊 ${entry.mood}/10', AppTheme.accent),
              const SizedBox(width: 8),
              _buildStatChip('⚡ ${entry.energy}/10', AppTheme.secondary),
              const SizedBox(width: 8),
              _buildStatChip('🌊 ${entry.stress}/10', AppTheme.primary),
            ],
          ),

          // Note if exists
          if (entry.note != null && entry.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notes,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    entry.note!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No check-ins yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your first Mind Check-In to see history here',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
