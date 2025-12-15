import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BlueInteractiveButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;

  const BlueInteractiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
  });

  @override
  State<BlueInteractiveButton> createState() => _BlueInteractiveButtonState();
}

class _BlueInteractiveButtonState extends State<BlueInteractiveButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final buttonColor = isEnabled ? AppTheme.primary : Colors.grey.withAlpha(128);

    List<BoxShadow> boxShadow;
    if (isEnabled) {
      if (_isHovered) {
        boxShadow = [
          BoxShadow(
            color: AppTheme.primary.withAlpha(102), // 40% opacity
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ];
      } else {
        boxShadow = [
          BoxShadow(
            color: AppTheme.primary.withAlpha(51), // 20% opacity
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ];
      }
    } else {
      boxShadow = [];
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: boxShadow,
            ),
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
