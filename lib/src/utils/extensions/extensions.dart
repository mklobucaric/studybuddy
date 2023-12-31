import 'package:flutter/material.dart';

/// A custom widget that creates an animated elevated button.
///
/// This widget animates the scale of the button when tapped.
/// [child] is the content displayed inside the button.
/// [onPressed] is the callback function that gets called when the button is pressed.
class AnimatedElevatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const AnimatedElevatedButton(
      {super.key, required this.child, this.onPressed});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedElevatedButtonState createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation
  late Animation<double> _scale; // Animation for scaling the button

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and scale animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) =>
          _controller.forward(), // Start the animation on tap down
      onTapUp: (_) => _controller.reverse(), // Reverse the animation on tap up
      onTapCancel: () => _controller
          .reverse(), // Reverse the animation if the tap is cancelled
      child: ScaleTransition(
        scale: _scale, // Apply the scale animation
        child: ElevatedButton(
          onPressed: widget.onPressed, // The callback provided in the widget
          child: widget.child, // The content provided in the widget
        ),
      ),
    );
  }
}
