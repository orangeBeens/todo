import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CelebrationOverlay extends StatelessWidget {
  final VoidCallback onAnimationComplete;

  const CelebrationOverlay({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Lottie.asset(
          'assets/animations/celebration.json',  // ローカルアセットパスに変更
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, onAnimationComplete);
          },
        ),
      ),
    );
  }
}