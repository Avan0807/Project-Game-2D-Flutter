import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:game2d/components/jump_button.dart';
import 'package:game2d/components/left_button.dart';
import 'package:game2d/components/player.dart';
import 'package:game2d/components/level.dart';
import 'package:game2d/components/right_button.dart';
import 'package:provider/provider.dart';
import 'package:game2d/sound_provider.dart';
import 'components/pause_button.dart';
import 'score_display.dart'; // Thêm import cho ScoreDisplay
import 'package:game2d/components/fruit.dart'; // Thêm import cho Fruit

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  final String character; // Thêm trường này
  final BuildContext context; // Thêm context

  late CameraComponent cam;
  late Player player;
  bool showControls = true;
  List<String> levelNames = ['level-01', 'level-02'];
  int currentLevelIndex = 0;
  int score = 0;
  late SoundProvider _soundProvider;

  PixelAdventure({
    required SoundProvider soundProvider,
    required this.character,
    required this.context, // Thêm context vào constructor
  }) : _soundProvider = soundProvider;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    player = Player(
      position: Vector2(100, 100),
      character: character, // Truyền nhân vật từ constructor
      soundProvider: _soundProvider,
    );

    _loadLevel();
    if (showControls) {
      add(JumpButton());
      add(RightButton());
      add(LeftButton());
    }

    add(player); // Đảm bảo player được thêm vào game

    // Thêm nút tạm dừng
    add(PauseButton(context));

    return super.onLoad();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(milliseconds: 100), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      )
        ..priority = 0
        ..viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderScore(canvas); // Render the score display
  }

  void renderScore(Canvas canvas) {
    final scoreDisplay = ScoreDisplay(score: score);
    scoreDisplay.render(canvas);
  }
}
