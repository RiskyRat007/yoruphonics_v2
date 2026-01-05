import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';

// -----------------------------------------------------------------------------
// Splash Screen with Talking + Blinking Ijapa 🐢
// -----------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  final String nextRoute;
  const SplashScreen({super.key, this.nextRoute = '/role-selection'});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _talkController;
  late AnimationController _blinkController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _mouthAnimation;
  late Animation<double> _blinkAnimation;
  final AudioPlayer _player = AudioPlayer();

  bool _isTalking = false;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for the splash screen
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Talking (mouth movement)
    _talkController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
          lowerBound: 0.0,
          upperBound: 8.0,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _talkController.reverse();
          } else if (status == AnimationStatus.dismissed && _isTalking) {
            _talkController.forward();
          }
        });
    _mouthAnimation = _talkController;

    // Eye blink animation (just squish the eyes a bit)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.7,
      upperBound: 1.0,
    );
    _blinkAnimation = CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    );

    // Blink every 2.5 seconds automatically
    Timer.periodic(const Duration(seconds: 3), (_) {
      _triggerBlink();
    });

    // Start voice after slight delay
    Future.delayed(const Duration(milliseconds: 800), _playIjapaVoice);

    // Navigate to next page
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  Future<void> _triggerBlink() async {
    if (!_isBlinking) {
      _isBlinking = true;
      await _blinkController.reverse();
      await Future.delayed(const Duration(milliseconds: 100));
      await _blinkController.forward();
      _isBlinking = false;
    }
  }

  Future<void> _playIjapaVoice() async {
    try {
      _isTalking = true;
      _talkController.forward();
      await _player.play(AssetSource('audio/ijapaintro.mp3'));

      // Stop animation when done
      _player.onPlayerComplete.listen((_) {
        setState(() {
          _isTalking = false;
        });
        _talkController.stop();
      });
    } catch (e) {
      print("Error playing Ijapa voice: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _fadeController.dispose();
    _talkController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playIjapaVoice, // for Chrome autoplay
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFB74D), Color(0xFFFFE082)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App title
                  Text(
                    'YoruPhonics',
                    style: GoogleFonts.fredoka(
                      fontSize: 36,
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Animated Ijapa 🐢
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _mouthAnimation,
                      _blinkAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -_mouthAnimation.value),
                        child: Transform.scale(
                          scaleY: _blinkAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset('assets/ijapamascot.png', height: 220),
                  ),
                  const SizedBox(height: 30),

                  // Text bubble
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: AnimatedTextKit(
                      repeatForever: false,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "E káàábò! I’m Ijapa. Let’s learn together!",
                          textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          speed: Duration(milliseconds: 90),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Loading animation
                  const SpinKitFadingCircle(color: Colors.white, size: 50.0),
                  const SizedBox(height: 20),

                  const Text(
                    "Loading lessons...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
