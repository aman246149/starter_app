import 'package:flutter/material.dart';
import 'package:starter_app/core/constants/constants.dart';

final class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: Opacity(
            opacity: isLoading
                ? OpacityConstants.highEmphasis
                : OpacityConstants.opaque,
            child: child,
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
