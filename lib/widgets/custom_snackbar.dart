import 'package:flutter/material.dart';

enum SnackBarType {
  locationDisabled,
  locationDenied,
  locationDeniedForever,
  noInternet,
}

class CustomSnackBar extends StatefulWidget {
  final SnackBarType type;
  final VoidCallback? onActionPressed;

  const CustomSnackBar({
    super.key,
    required this.type,
    this.onActionPressed,
  });

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _message {
    switch (widget.type) {
      case SnackBarType.locationDisabled:
        return 'Location services are disabled';
      case SnackBarType.locationDenied:
        return 'Location permission denied';
      case SnackBarType.locationDeniedForever:
        return 'Location permissions are permanently denied';
      case SnackBarType.noInternet:
        return 'No internet connection';
    }
  }

  String? get _actionLabel {
    switch (widget.type) {
      case SnackBarType.locationDisabled:
        return 'Enable';
      case SnackBarType.locationDenied:
        return 'Allow';
      case SnackBarType.locationDeniedForever:
        return 'Settings';
      case SnackBarType.noInternet:
        return 'Retry';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case SnackBarType.locationDisabled:
      case SnackBarType.locationDenied:
      case SnackBarType.locationDeniedForever:
        return Icons.location_off;
      case SnackBarType.noInternet:
        return Icons.wifi_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _icon,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  if (widget.onActionPressed != null &&
                      _actionLabel != null) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: widget.onActionPressed,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      child: Text(_actionLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
