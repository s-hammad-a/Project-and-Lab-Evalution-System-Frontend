import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
        body: Center(
          child: LoadingAnimationWidget.discreteCircle(
            //leftDotColor: const Color(0xFF1A1A3F),
            //rightDotColor: const Color(0xFFEA3799),
            size: 200,
            color: Colors.white,
            secondRingColor:  Colors.green.shade900,
            thirdRingColor: Colors.orange
          ),
        ),
    );
  }
}
