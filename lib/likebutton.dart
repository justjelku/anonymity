import 'package:finalproject/constant.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _liked = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: IconButton(
            icon: _liked ? const Icon(Icons.favorite) : Icon(Icons.favorite_border, color: mainTextColor,),
            color: _liked ? Colors.red : null,
            onPressed: () {
              setState(() {
                _liked = !_liked;
              });

              if (_liked) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
