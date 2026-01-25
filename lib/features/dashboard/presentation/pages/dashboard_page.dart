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

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final l10n = context.dashboardL10n;
    const boxCount = 20;
    const randomLimit = 255;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appBarTitle)),
      body: ResponsiveGrid.builder(
        itemCount: boxCount,
        itemBuilder: (context, index) => ColoredBox(
          color: Color.fromARGB(
            (index + 1) * randomLimit ~/ 4,
            random.nextInt(randomLimit),
            random.nextInt(randomLimit),
            random.nextInt(randomLimit),
          ),
        ),
      ),
    );
  }
}
