import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class CalmScreen extends StatefulWidget {
  const CalmScreen({super.key});

  @override
  State<CalmScreen> createState() => _CalmScreenState();
}

class _CalmScreenState extends State<CalmScreen> with TickerProviderStateMixin {
  // Breathing exercise state
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  bool _isBreathing = false;
  String _breathPhase = 'Press Start';
  int _breathCycle = 0;
  Timer? _breathTimer;

  // Selected tool
  int _selectedTool = 0;

  final List<Map<String, dynamic>> _calmTools = [
    {
      'title': 'Box Breathing',
      'icon': Icons.air,
      'color': AppTheme.primary,
      'description': '4-4-4-4 technique to reduce anxiety instantly',
    },
    {
      'title': '5-4-3-2-1 Grounding',
      'icon': Icons.psychology_outlined,
      'color': AppTheme.secondary,
      'description': 'Anchor yourself to the present moment',
    },
    {
      'title': 'Thought Reframe',
      'icon': Icons.lightbulb_outline,
      'color': AppTheme.warning,
      'description': 'CBT-style technique to challenge negative thoughts',
    },
    {
      'title': 'Micro Break',
      'icon': Icons.free_breakfast_outlined,
      'color': const Color(0xFF4CAF50),
      'description': 'Quick 5-minute reset for your mind',
    },
  ];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breathAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    _breathTimer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    if (_isBreathing) {
      _stopBreathing();
      return;
    }

    setState(() {
      _isBreathing = true;
      _breathCycle = 0;
    });

    _runBreathCycle();
  }

  void _runBreathCycle() {
    // Inhale 4s
    setState(() => _breathPhase = 'Inhale... 🌬️');
    _breathController.forward(from: 0);

    _breathTimer = Timer(const Duration(seconds: 4), () {
      if (!_isBreathing) return;
      // Hold 4s
      setState(() => _breathPhase = 'Hold... ⏸️');
      _breathTimer = Timer(const Duration(seconds: 4), () {
        if (!_isBreathing) return;
        // Exhale 4s
        setState(() => _breathPhase = 'Exhale... 💨');
        _breathController.reverse();
        _breathTimer = Timer(const Duration(seconds: 4), () {
          if (!_isBreathing) return;
          // Hold 4s
          setState(() => _breathPhase = 'Hold... ⏸️');
          _breathTimer = Timer(const Duration(seconds: 4), () {
            if (!_isBreathing) return;
            setState(() => _breathCycle++);
            if (_breathCycle < 5) {
              _runBreathCycle();
            } else {
              _stopBreathing();
              setState(() => _breathPhase = 'Well done! 🌟');
            }
          });
        });
      });
    });
  }

  void _stopBreathing() {
    _breathTimer?.cancel();
    _breathController.stop();
    _breathController.reset();
    setState(() {
      _isBreathing = false;
      _breathPhase = 'Press Start';
      _breathCycle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calm Toolkit'),
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
              // ─── Header ────────────────────────────────
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
                    const Icon(Icons.spa, color: AppTheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Take a moment for yourself. Yahan safe ho tum 💙',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Tool Selector ─────────────────────────
              Text(
                'Choose a Tool',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _calmTools.length,
                  itemBuilder: (context, index) {
                    final tool = _calmTools[index];
                    final isSelected = _selectedTool == index;
                    return GestureDetector(
                      onTap: () {
                        _stopBreathing();
                        setState(() => _selectedTool = index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (tool['color'] as Color).withValues(alpha: 0.2)
                              : AppTheme.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? tool['color'] as Color
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              tool['icon'] as IconData,
                              color: isSelected
                                  ? tool['color'] as Color
                                  : AppTheme.textSecondary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              tool['title'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? tool['color'] as Color
                                    : AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ─── Tool Content ──────────────────────────
              _buildToolContent(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolContent() {
    switch (_selectedTool) {
      case 0:
        return _buildBreathingExercise();
      case 1:
        return _buildGrounding();
      case 2:
        return _buildThoughtReframe();
      case 3:
        return _buildMicroBreak();
      default:
        return _buildBreathingExercise();
    }
  }

  Widget _buildBreathingExercise() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                'Box Breathing',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Inhale → Hold → Exhale → Hold (4s each)',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Breathing circle
              AnimatedBuilder(
                animation: _breathAnimation,
                builder: (context, child) {
                  return Container(
                    width: 180 * _breathAnimation.value,
                    height: 180 * _breathAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _breathPhase,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppTheme.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              if (_isBreathing)
                Text(
                  'Cycle ${_breathCycle + 1} of 5',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.primary),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startBreathing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isBreathing
                        ? AppTheme.accent
                        : AppTheme.primary,
                  ),
                  child: Text(_isBreathing ? 'Stop' : 'Start Breathing'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrounding() {
    final steps = [
      {'number': '5', 'sense': 'things you can SEE 👁️'},
      {'number': '4', 'sense': 'things you can TOUCH ✋'},
      {'number': '3', 'sense': 'things you can HEAR 👂'},
      {'number': '2', 'sense': 'things you can SMELL 👃'},
      {'number': '1', 'sense': 'thing you can TASTE 👅'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5-4-3-2-1 Grounding',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Focus on your senses to bring yourself back to the present moment.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...steps.map(
            (step) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        step['number']!,
                        style: TextStyle(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Notice ${step['number']} ${step['sense']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThoughtReframe() {
    final prompts = [
      'What evidence do I have that this thought is true?',
      'What would I tell a friend in this exact situation?',
      'Is this thought a fact or just a feeling?',
      'What is ONE small thing I can control right now?',
      'Will this matter in 1 week? 1 month? 1 year?',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thought Reframing',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Ask yourself these questions when negative thoughts take over.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...prompts.asMap().entries.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: AppTheme.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroBreak() {
    final activities = [
      {
        'icon': '💧',
        'title': 'Hydrate',
        'desc': 'Drink a full glass of water slowly',
      },
      {
        'icon': '🚶',
        'title': 'Walk',
        'desc': 'Take 20 steps away from your screen',
      },
      {
        'icon': '🙆',
        'title': 'Stretch',
        'desc': 'Roll your shoulders back 5 times',
      },
      {
        'icon': '👀',
        'title': '20-20-20',
        'desc': 'Look 20ft away for 20 seconds',
      },
      {
        'icon': '😊',
        'title': 'Smile',
        'desc': 'Smile for 10 seconds — it actually helps!',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5-Minute Micro Break',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Do all 5 of these in 5 minutes for a full mental reset.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...activities.map(
            (activity) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Text(activity['icon']!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          activity['desc']!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
