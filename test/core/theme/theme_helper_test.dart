import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/theme/app_theme.dart';
import 'package:starter_app/core/theme/theme_helper.dart';

void main() {
  group('ThemeHelper', () {
    const appTheme = AppTheme();

    testWidgets('accesses theme colors correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(ThemeHelper.primaryColor(context), isA<Color>());
              expect(ThemeHelper.secondaryColor(context), isA<Color>());
              expect(ThemeHelper.errorColor(context), isA<Color>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('accesses semantic colors correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(ThemeHelper.successColor(context), isA<Color>());
              expect(ThemeHelper.warningColor(context), isA<Color>());
              expect(ThemeHelper.infoColor(context), isA<Color>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('accesses text styles correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(ThemeHelper.headlineLarge(context), isA<TextStyle>());
              expect(ThemeHelper.headlineMedium(context), isA<TextStyle>());
              expect(ThemeHelper.bodyLarge(context), isA<TextStyle>());
              expect(ThemeHelper.bodyMedium(context), isA<TextStyle>());
              expect(ThemeHelper.labelLarge(context), isA<TextStyle>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('detects theme mode correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: Builder(
            builder: (context) {
              expect(ThemeHelper.isLightMode(context), true);
              expect(ThemeHelper.isDarkMode(context), false);
              expect(ThemeHelper.brightness(context), Brightness.light);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('gets brightness for dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              expect(ThemeHelper.brightness(context), Brightness.dark);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('gets surface tint color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(ThemeHelper.surfaceTint(context), isA<Color>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('gets elevated surface color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(
                ThemeHelper.elevatedSurface(
                  context,
                ),
                isA<Color>(),
              );
              expect(
                ThemeHelper.elevatedSurface(context, level: 2),
                isA<Color>(),
              );
              expect(
                ThemeHelper.elevatedSurface(context, level: 5),
                isA<Color>(),
              );
              // Test with level beyond array bounds
              expect(
                ThemeHelper.elevatedSurface(context, level: 10),
                isA<Color>(),
              );
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ThemeContextExtension', () {
    const appTheme = AppTheme();

    testWidgets('provides convenient accessors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          home: Builder(
            builder: (context) {
              expect(context.theme, isA<ThemeData>());
              expect(context.colorScheme, isA<ColorScheme>());
              expect(context.textTheme, isA<TextTheme>());
              expect(context.primaryColor, isA<Color>());
              expect(context.secondaryColor, isA<Color>());
              expect(context.backgroundColor, isA<Color>());
              expect(context.surfaceColor, isA<Color>());
              expect(context.errorColor, isA<Color>());
              expect(context.onPrimary, isA<Color>());
              expect(context.onSecondary, isA<Color>());
              expect(context.onSurface, isA<Color>());
              expect(context.onError, isA<Color>());
              expect(context.isLightMode, isTrue);
              expect(context.isDarkMode, isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('isDarkMode returns true for dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              expect(context.isDarkMode, isTrue);
              expect(context.isLightMode, isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
