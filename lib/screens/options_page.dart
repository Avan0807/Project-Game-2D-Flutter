import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game2d/sound_provider.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      body: Column(
        children: [
          Consumer<SoundProvider>(
            builder: (context, soundProvider, _) {
              return SwitchListTile(
                title: Text('Play Sounds'),
                value: soundProvider.playSounds,
                onChanged: (newValue) {
                  soundProvider.togglePlaySounds();
                },
              );
            },
          ),
          Slider(
            value: Provider.of<SoundProvider>(context).soundVolume,
            min: 0.0,
            max: 1.0,
            onChanged: (newValue) {
              Provider.of<SoundProvider>(context, listen: false).setSoundVolume(newValue);
            },
          ),
        ],
      ),
    );
  }
}
