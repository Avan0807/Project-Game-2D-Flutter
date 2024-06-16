import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:game2d/pixel_adventure.dart';
import 'package:game2d/sound_provider.dart';

class GamePlay extends StatelessWidget {
  final String? character;

  const GamePlay({Key? key, this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: kDebugMode
          ? PixelAdventure(
        soundProvider: SoundProvider(),
        character: character ?? '',
        context: context, // Truyền context ở đây
      )
          : PixelAdventure(
        soundProvider: SoundProvider(),
        character: character ?? '',
        context: context, // Truyền context ở đây
      ),
    );
  }
}
