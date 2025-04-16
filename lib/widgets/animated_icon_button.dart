import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedIconButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedIconButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 3.1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePressed() async {
    // Trigger animation
    await _controller.forward();
    await _controller.reverse();

    // Execute the button's main action
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _controller.value,
          child: child,
        );
      },
      child: IconButton(
        onPressed: _handlePressed,
        icon: SvgPicture.asset('images/heart-filled.svg'),
      ),
    );
  }
}
