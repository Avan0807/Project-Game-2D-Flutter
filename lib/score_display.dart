import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game2d/screens/game_state.dart';

class ScoreDisplay extends PositionComponent {
  final int score;

  ScoreDisplay({required this.score});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: ${GameState.score}',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10)); // Vị trí để hiển thị điểm số

    // Lưu điểm số mới nhất
    GameState.updateScore(score);
    GameState.saveScoreToDatabase(score);
  }
}
