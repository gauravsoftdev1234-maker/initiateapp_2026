// FindingPeopleOverlay.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../testibg.dart';
import 'mainscreen.dart';

class FindingPeopleOverlay extends StatefulWidget {
  final String message;
  final VoidCallback? onCancel;
  final bool showCancelButton;
  final String? profileImageUrl;

  const FindingPeopleOverlay({
    super.key,
    required this.message,
    this.onCancel,
    this.showCancelButton = true,
    this.profileImageUrl,
  });

  @override
  State<FindingPeopleOverlay> createState() => _FindingPeopleOverlayState();
}

class _FindingPeopleOverlayState extends State<FindingPeopleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Animated profile avatar with pulse effect
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppThemeX.red.withOpacity(_opacityAnimation.value * 0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppThemeX.red.withOpacity(0.2 * _opacityAnimation.value),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: widget.profileImageUrl != null &&
                            widget.profileImageUrl!.isNotEmpty
                            ? Image.network(
                          widget.profileImageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppThemeX.red,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[100],
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          ),
                        )
                            : Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              // Message text
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppThemeX.text,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle text
              const Text(
                'This may take a few seconds',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppThemeX.sub,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppThemeX.red.withOpacity(0.8)),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              if (widget.showCancelButton) ...[
                const SizedBox(height: 30),
                TextButton(
                  onPressed: widget.onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: AppThemeX.sub,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}