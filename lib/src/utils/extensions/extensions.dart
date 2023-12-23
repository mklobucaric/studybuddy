import 'package:flutter/material.dart';

class AnimatedElevatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const AnimatedElevatedButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  @override
  _AnimatedElevatedButtonState createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
