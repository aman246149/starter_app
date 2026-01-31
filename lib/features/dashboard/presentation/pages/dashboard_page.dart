import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/responsive/responsive.dart';
import 'package:starter_app/features/dashboard/l10n/l10n_extensions.dart';

/// Dashboard page displaying a responsive grid layout.
///
/// This page demonstrates the responsive grid system with colored boxes
/// that adapt to different screen sizes.

final class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  /// Pre-generated colors ensure consistent appearance across rebuilds.
  static final List<Color> _colors = List.generate(20, (index) {
    final random = Random(index); // Seeded for deterministic colors
    const limit = 255;
    return Color.fromARGB(
      (index + 1) * limit ~/ 4,
      random.nextInt(limit),
      random.nextInt(limit),
      random.nextInt(limit),
    );
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.dashboardL10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appBarTitle)),
      body: ResponsiveGrid.builder(
        itemCount: _colors.length,
        itemBuilder: (context, index) => ColoredBox(color: _colors[index]),
      ),
    );
  }
}
