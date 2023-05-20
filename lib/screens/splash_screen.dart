import 'package:flutter/material.dart';

import '../widgets/decoration_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: CustomLinearGradient.baseBackgroundDecoration(
          const Color(0xFF495579),
          const Color(0xFF3C2A21),
        )),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
