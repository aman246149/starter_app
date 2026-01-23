import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starter_app/core/domain/value_objects/password.dart';
import 'package:starter_app/core/error/failures/password_failure.dart';
import 'package:starter_app/core/presentation/widgets/app_text_field.dart';

/// Password text field with visibility toggle.
///
/// Builds on top of [AppTextField] to provide password-specific functionality:
/// - Text obscuring (controlled by [obscureText] parameter)
/// - Visibility toggle button
/// - Appropriate keyboard type
/// - Single-line input
///
/// The visibility state is managed externally (typically by a BLoC or Cubit).
///
/// Example:
/// ```dart
/// PasswordTextField(
///   password: Password(''),
///   showError: false,
///   obscureText: !state.passwordVisible,
///   onToggleVisibility: () => context.read<AuthBloc>().add(
///     const AuthEvent.togglePasswordVisibility(),
///   ),
///   label: 'Password',
///   hint: 'Enter your password',
/// )
/// ```
final class PasswordTextField extends StatelessWidget {
  /// Creates a password text field.
  const PasswordTextField({
    required this.password,
    required this.showError,
    required this.obscureText,
    this.onToggleVisibility,
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.focusNode,
    this.initialValue,
    this.autovalidateMode,
  });

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed when field is empty.
  final String? hint;

  /// Helper text displayed below the field.
  final String? helperText;

  /// Error text displayed below the field (overrides helperText).
  final String? errorText;

  /// Whether the field is enabled for input.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field should autofocus on mount.
  final bool autofocus;

  /// Text input action for the keyboard.
  final TextInputAction? textInputAction;

  /// Maximum character length.
  final int? maxLength;

  /// Input formatters for text transformation/filtering.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Callback when text changes.
  final void Function(String)? onChanged;

  /// Callback when field is submitted.
  final void Function(String)? onSubmitted;

  /// Callback when editing is complete (user presses done/next or taps outside).
  final VoidCallback? onEditingComplete;

  /// Callback when field is tapped.
  final VoidCallback? onTap;

  /// Focus node for managing focus.
  final FocusNode? focusNode;

  /// Initial value for the field (used when no controller is provided).
  final String? initialValue;

  /// Auto-validation mode.
  final AutovalidateMode? autovalidateMode;

  /// Password value object.
  final Password password;

  /// Whether to show validation error messages.
  final bool showError;

  /// Whether to obscure the password text.
  ///
  /// When true, the password is hidden. When false, the password is visible.
  /// This is typically controlled by BLoC state.
  final bool obscureText;

  /// Callback when the visibility toggle button is pressed.
  ///
  /// Typically dispatches an event to toggle `passwordVisible` in BLoC state.
  final VoidCallback? onToggleVisibility;

  /// Gets the first relevant error message from password failures.
  String? _getErrorMessage() {
    if (!showError) return null;

    final failures = password.getFailuresOrNull();
    if (failures == null || failures.isEmpty) return null;

    // Use the message property from the first failure
    final first = failures.first;
    if (first is PasswordFailure) {
      return first.message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: _getErrorMessage(),
      prefixIcon: const Icon(Icons.lock_outlined),
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      focusNode: focusNode,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      suffixIcon: IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: enabled ? onToggleVisibility : null,
      ),
      autofillHints: const [AutofillHints.password],
    );
  }
}
