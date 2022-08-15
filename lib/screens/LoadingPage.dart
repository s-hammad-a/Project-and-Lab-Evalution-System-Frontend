import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        body: Center(
          child: LoadingAnimationWidget.discreteCircle(
            //leftDotColor: const Color(0xFF1A1A3F),
            //rightDotColor: const Color(0xFFEA3799),
            size: 50,
            color: Colors.blue.shade300,
            secondRingColor:  Colors.green.shade900,
            thirdRingColor: Colors.orange
          ),
        ),
    );
  }
}
