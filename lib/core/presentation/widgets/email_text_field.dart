import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/error/failures/email_failure.dart';
import 'package:starter_app/core/presentation/widgets/app_text_field.dart';

/// Email text field with proper validation and autofill.
///
/// Builds on top of [AppTextField] to provide email-specific functionality:
/// - Email keyboard type
/// - Email autofill hints
/// - Email-specific validation messages from [EmailAddress] value object
///
/// Example:
/// ```dart
/// EmailTextField(
///   email: state.email,
///   showError: state.validation.emailTouched,
///   onChanged: (value) => bloc.add(EmailChanged(value)),
///   onEditingComplete: () => bloc.add(EmailUnfocused()),
/// )
/// ```
final class EmailTextField extends StatelessWidget {
  /// Creates an email text field.
  const EmailTextField({
    required this.email,
    required this.showError,
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
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

  /// Widget displayed at the start of the field.
  final Widget? prefixIcon;

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

  /// Email address value object.
  final EmailAddress email;

  /// Whether to show validation error messages.
  final bool showError;

  /// Gets the first relevant error message from email failures.
  String? _getErrorMessage() {
    if (!showError) return null;

    final failures = email.getFailuresOrNull();
    if (failures == null || failures.isEmpty) return null;

    // Use the message property from the first failure
    final first = failures.first;
    if (first is EmailFailure) {
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
      prefixIcon: const Icon(Icons.email_outlined),
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      keyboardType: TextInputType.emailAddress,
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
      autofillHints: const [AutofillHints.email],
    );
  }
}
