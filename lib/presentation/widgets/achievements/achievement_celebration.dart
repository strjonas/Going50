import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:going50/core/theme/app_colors.dart';

/// A widget that displays a celebration animation when a user unlocks an achievement
///
/// This widget shows a visually rewarding animation to celebrate achievement unlocks,
/// making the achievement experience more engaging and satisfying.
class AchievementCelebration extends StatefulWidget {
  /// Title of the achievement
  final String title;
  
  /// Description of the achievement
  final String description;
  
  /// Icon to display
  final IconData icon;
  
  /// Whether to auto-dismiss after a certain duration
  final bool autoDismiss;
  
  /// Callback when the celebration is dismissed
  final VoidCallback? onDismiss;
  
  /// Duration before auto-dismissing (if autoDismiss is true)
  final Duration autoDismissDuration;
  
  /// Constructor
  const AchievementCelebration({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.autoDismiss = true,
    this.onDismiss,
    this.autoDismissDuration = const Duration(seconds: 5),
  });

  @override
  State<AchievementCelebration> createState() => _AchievementCelebrationState();
}

class _AchievementCelebrationState extends State<AchievementCelebration> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _shineController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _shineAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Entry animations
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    
    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: -0.05, end: 0.05), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.05, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(0.4, 0.6, curve: Curves.easeInOut),
      ),
    );
    
    // Shine animation
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shineController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Confetti animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    // Start animations in sequence
    _entryController.forward().then((_) {
      _shineController.repeat(min: -1.0, max: 2.0, period: const Duration(milliseconds: 2000));
      _confettiController.forward();
      
      // Auto-dismiss if enabled
      if (widget.autoDismiss) {
        Future.delayed(widget.autoDismissDuration, () {
          if (mounted) {
            _dismiss();
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _entryController.dispose();
    _shineController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
  
  /// Dismiss the celebration
  void _dismiss() {
    Navigator.of(context).pop();
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: _dismiss,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_entryController, _shineController, _confettiController]),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti particles
                  ...List.generate(30, (i) {
                    final random = math.Random(i);
                    final size = random.nextDouble() * 10 + 5;
                    final angle = random.nextDouble() * math.pi * 2;
                    final maxDistance = MediaQuery.of(context).size.width * 0.45;
                    final distance = maxDistance * _confettiController.value;
                    final opacity = 1.0 - _confettiController.value;
                    final baseColor = [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.ecoScoreHigh,
                      AppColors.ecoScoreLow,
                      AppColors.ecoScoreMedium,
                    ][random.nextInt(5)];
                    
                    return Positioned(
                      left: MediaQuery.of(context).size.width / 2 + math.cos(angle) * distance,
                      top: MediaQuery.of(context).size.height / 2 + math.sin(angle) * distance,
                      child: Opacity(
                        opacity: opacity > 0 ? opacity : 0,
                        child: Transform.rotate(
                          angle: angle,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: baseColor.withOpacity(0.9),
                              shape: random.nextBool() ? BoxShape.circle : BoxShape.rectangle,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  
                  // Main achievement card
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotateAnimation.value * math.pi,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ecoScoreHigh.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.ecoScoreHigh,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Achievement unlocked banner
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.ecoScoreHigh.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.ecoScoreHigh,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: AppColors.ecoScoreHigh,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Achievement Unlocked!',
                                    style: TextStyle(
                                      color: AppColors.ecoScoreHigh,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Badge icon
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Shine effect around the badge
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.ecoScoreHigh.withOpacity(0.7),
                                        AppColors.ecoScoreHigh.withOpacity(0.0),
                                      ],
                                      stops: const [0.7, 1.0],
                                    ),
                                  ),
                                ),
                                
                                // Badge container with shine effect
                                ClipOval(
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: AppColors.ecoScoreHigh.withOpacity(0.2),
                                    child: Stack(
                                      children: [
                                        // Icon
                                        Center(
                                          child: Icon(
                                            widget.icon,
                                            size: 40,
                                            color: AppColors.ecoScoreHigh,
                                          ),
                                        ),
                                        
                                        // Shine overlay
                                        Transform.rotate(
                                          angle: math.pi / 4,
                                          child: Transform.translate(
                                            offset: Offset(
                                              _shineAnimation.value * 150,
                                              0,
                                            ),
                                            child: Container(
                                              width: 40,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white.withOpacity(0),
                                                    Colors.white.withOpacity(0.4),
                                                    Colors.white.withOpacity(0),
                                                  ],
                                                  stops: const [0.0, 0.5, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Achievement title
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Achievement description
                            Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Dismiss button
                            TextButton(
                              onPressed: _dismiss,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                              ),
                              child: const Text('Awesome!'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Shows the achievement celebration dialog
void showAchievementCelebration(
  BuildContext context, {
  required String title,
  required String description,
  required IconData icon,
  bool autoDismiss = true,
  VoidCallback? onDismiss,
  Duration autoDismissDuration = const Duration(seconds: 5),
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AchievementCelebration(
      title: title,
      description: description,
      icon: icon,
      autoDismiss: autoDismiss,
      onDismiss: onDismiss,
      autoDismissDuration: autoDismissDuration,
    ),
  );
} 