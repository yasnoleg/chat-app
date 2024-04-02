import 'package:flutter/material.dart';

class HeartReaction extends StatefulWidget {
  Widget child;
  HeartReaction({super.key, required this.child});

  @override
  State<HeartReaction> createState() => _HeartReactionState();
}

class _HeartReactionState extends State<HeartReaction> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 0.2
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: widget.child,
        ),
      ),
    );
  }
}