import 'package:flutter/material.dart';
import 'package:going50/core/theme/app_colors.dart';

/// A large, visually prominent eco-score display.
///
/// This component is designed to be the focal point of the active driving screen,
/// showing the driver's current eco-score in a minimalist, distraction-free way.
class EcoScoreDisplay extends StatelessWidget {
  /// The current eco-score value (0-100)
  final double ecoScore;
  
  /// Constructor
  const EcoScoreDisplay({
    super.key,
    required this.ecoScore,
  });

  @override
  Widget build(BuildContext context) {
    final score = ecoScore.toInt();
    final ecoScoreColor = AppColors.getEcoScoreColor(ecoScore);
    final message = _getEcoScoreMessage(score);
    
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Score value display
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: ecoScoreColor,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: ecoScoreColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Score number
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: ecoScoreColor,
                    ),
                  ),
                  // Score label
                  Text(
                    'ECO-SCORE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ecoScoreColor.withOpacity(0.8),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Feedback message
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ecoScoreColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Returns a message based on the current eco-score
  String _getEcoScoreMessage(int score) {
    if (score < 30) {
      return 'Room for improvement';
    } else if (score < 50) {
      return 'Getting better';
    } else if (score < 70) {
      return 'Good driving';
    } else if (score < 90) {
      return 'Great eco-driving!';
    } else {
      return 'Eco-driving master!';
    }
  }
} 