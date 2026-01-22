import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/theme/text_styles.dart';

void main() {
  group('AppTextStyles', () {
    test('getTextTheme returns TextTheme with all styles', () {
      final textTheme = AppTextStyles.getTextTheme();

      // Verify all display styles are present
      expect(textTheme.displayLarge, AppTextStyles.displayLarge);
      expect(textTheme.displayMedium, AppTextStyles.displayMedium);
      expect(textTheme.displaySmall, AppTextStyles.displaySmall);

      // Verify all headline styles are present
      expect(textTheme.headlineLarge, AppTextStyles.headlineLarge);
      expect(textTheme.headlineMedium, AppTextStyles.headlineMedium);
      expect(textTheme.headlineSmall, AppTextStyles.headlineSmall);

      // Verify all title styles are present
      expect(textTheme.titleLarge, AppTextStyles.titleLarge);
      expect(textTheme.titleMedium, AppTextStyles.titleMedium);
      expect(textTheme.titleSmall, AppTextStyles.titleSmall);

      // Verify all label styles are present
      expect(textTheme.labelLarge, AppTextStyles.labelLarge);
      expect(textTheme.labelMedium, AppTextStyles.labelMedium);
      expect(textTheme.labelSmall, AppTextStyles.labelSmall);

      // Verify all body styles are present
      expect(textTheme.bodyLarge, AppTextStyles.bodyLarge);
      expect(textTheme.bodyMedium, AppTextStyles.bodyMedium);
      expect(textTheme.bodySmall, AppTextStyles.bodySmall);
    });
  });
}
