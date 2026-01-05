import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  // Assets
  static const String ijapaIntro = 'audio/ijapaintro.mp3';
  static const String pupilWelcome = 'audio/ijapa_pupilwelcome.mp3';
  static const String teacherWelcome = 'audio/teacherwelcomeback.mp3';
  static const String excellent = 'audio/excellentomodaadaa.mp3';
  static const String tryAgain = 'audio/tryagain.mp3';
  static const String star = 'audio/phonicstar.mp3';
  static const String superStar = 'audio/superstar.mp3';
  static const String jekalo = 'audio/jekalo.mp3';

  Future<void> playAsset(String path) async {
    try {
      await _player.stop(); // Stop any previous sound
      await _player.play(AssetSource(path));
    } catch (e) {
      print("Error playing audio asset $path: $e");
    }
  }

  void dispose() {
    _player.dispose();
  }
}
