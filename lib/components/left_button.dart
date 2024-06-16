import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:game2d/pixel_adventure.dart';

class LeftButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  LeftButton();

  @override
  FutureOr<void> onLoad() {
    double screenWidth = game.size[0];
    double screenHeight = game.size[1];
    double xmargin = screenWidth * 0.90; // 10% of screen width
    double ymargin = screenHeight * 0.02; // 2% of screen height

    double buttonSize = screenWidth * 0.08; // 8% of screen width
    double buttonGap = screenWidth * 0.05; // 5% of screen width
    sprite = Sprite(game.images.fromCache('HUD/LeftButton.png'));
    size = Vector2.all(buttonSize);
    position = Vector2(
      screenWidth - xmargin + buttonSize - buttonGap,
      screenHeight - ymargin - buttonSize,
    );
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.horizontalMovement = -1;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.horizontalMovement = 0;
    super.onTapUp(event);
  }
}
