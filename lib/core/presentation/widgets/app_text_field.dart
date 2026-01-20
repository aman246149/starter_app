import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Domain-agnostic custom text field widget.
///
/// Provides consistent styling and behavior for all text inputs.
/// Styling is determined by the theme's InputDecorationTheme.
///
/// This widget has no knowledge of specific use cases (password, email, etc.).
/// For specialized fields, create wrapper widgets that configure this field.
///
/// Features:
/// - Theme-driven styling
/// - Validation support
/// - Optional text obscuring
/// - Prefix and suffix icons
/// - Error/helper text display
/// - Full TextFormField functionality
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   keyboardType: TextInputType.emailAddress,
///   prefixIcon: Icon(Icons.email_outlined),
///   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
/// )
/// ```
final class AppTextField extends StatelessWidget {
  /// Creates a domain-agnostic text field.
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
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
    this.autofillHints,
  });

  /// Controller for the text field.
  final TextEditingController? controller;

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

  /// Widget displayed at the end of the field.
  final Widget? suffixIcon;

  /// Whether to obscure the text (useful for passwords, PINs, etc.).
  final bool obscureText;

  /// Whether the field is enabled for input.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field should autofocus on mount.
  final bool autofocus;

  /// Keyboard type for the input.
  final TextInputType? keyboardType;

  /// Text input action for the keyboard.
  final TextInputAction? textInputAction;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

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

  /// Autofill hints.
  final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
