import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final double delay;
  
  const DelayedAnimation({
    required this.child,
    required this.delay,
    super.key,
  });

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _offset = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    
    Future.delayed(Duration(milliseconds: widget.delay.toInt()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offset.value),
          child: Opacity(
            opacity: _opacity.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class LottieAnimation {
  static Widget asset(String path, 
      {double? width, double? height, BoxFit? fit}) {
    return Lottie.asset(
      path,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      animate: true,
      repeat: true,
    );
  }
}