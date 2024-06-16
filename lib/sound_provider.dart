import 'package:flutter/foundation.dart';

class SoundProvider extends ChangeNotifier {
  bool _playSounds = true;
  double _soundVolume = 1.0;

  bool get playSounds => _playSounds;
  double get soundVolume => _soundVolume;

  void togglePlaySounds() {
    _playSounds = !_playSounds;
    notifyListeners();
  }

  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }
}
