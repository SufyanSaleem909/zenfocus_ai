import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import '../services/ai_service.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  double _mood = 5;
  double _energy = 5;
  double _stress = 5;
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;
  String? _aiTip;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitCheckIn() async {
    setState(() => _isLoading = true);

    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: _mood.round(),
      energy: _energy.round(),
      stress: _stress.round(),
      note: _noteController.text.isEmpty ? null : _noteController.text,
      timestamp: DateTime.now(),
    );

    await StorageService.saveMoodEntry(entry);

    final tip = await AiService.getWellnessTip(
      _mood.round(),
      _energy.round(),
      _stress.round(),
    );

    setState(() {
      _isLoading = false;
      _aiTip = tip;
    });
  }

  Color _getSliderColor(double value) {
    if (value <= 3) return AppTheme.accent;
    if (value <= 6) return AppTheme.warning;
    return AppTheme.success;
  }

  Color _getStressColor(double value) {
    if (value <= 3) return AppTheme.success;
    if (value <= 6) return AppTheme.warning;
    return AppTheme.accent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Check-In'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Intro ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Be honest with yourself. No judgement here 💙',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ─── Mood Slider ───────────────────────────
              _buildSliderSection(
                context,
                label: 'Mood',
                emoji: '😊',
                value: _mood,
                color: _getSliderColor(_mood),
                onChanged: (v) => setState(() => _mood = v),
              ),

              const SizedBox(height: 24),

              // ─── Energy Slider ─────────────────────────
              _buildSliderSection(
                context,
                label: 'Energy',
                emoji: '⚡',
                value: _energy,
                color: _getSliderColor(_energy),
                onChanged: (v) => setState(() => _energy = v),
              ),

              const SizedBox(height: 24),

              // ─── Stress Slider ─────────────────────────
              _buildSliderSection(
                context,
                label: 'Stress',
                emoji: '🌊',
                value: _stress,
                color: _getStressColor(_stress),
                onChanged: (v) => setState(() => _stress = v),
                isReversed: true,
              ),

              const SizedBox(height: 24),

              // ─── Note Field ────────────────────────────
              Text(
                'Any notes? (optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind today?',
                ),
              ),

              const SizedBox(height: 28),

              // ─── Submit Button ─────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitCheckIn,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Get My Wellness Tip'),
                ),
              ),

              // ─── AI Tip ────────────────────────────────
              if (_aiTip != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withValues(alpha: 0.2),
                        AppTheme.secondary.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: AppTheme.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tranquil Study AI says:',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppTheme.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _aiTip!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primary),
                            foregroundColor: AppTheme.primary,
                          ),
                          child: const Text('Back to Home'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSection(
    BuildContext context, {
    required String label,
    required String emoji,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
    bool isReversed = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(label, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.round()}/10',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            overlayColor: color.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isReversed ? 'Calm 🌿' : 'Very Low',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 11),
            ),
            Text(
              isReversed ? 'Very High 🔴' : 'Excellent',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
