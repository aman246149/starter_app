import 'package:flutter/material.dart';

/// Animation curve constants for consistent motion.
///
/// These curves complement DurationConstants to provide complete
/// animation configuration. They follow Material Design 3 motion
/// principles for natural, responsive animations.
abstract final class AnimationConstants {
  /// Standard Material easing curve (ease-in-out cubic)
  ///
  /// Use for most animations: transitions, fades, scales.
  static const Curve standard = Curves.easeInOutCubic;

  /// Emphasized curve for larger/more important motion
  ///
  /// Use for significant state changes or attention-grabbing animations.
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Decelerate curve for entering elements
  ///
  /// Use when elements appear on screen (fade in, slide in).
  static const Curve decelerate = Curves.decelerate;

  /// Accelerate curve for exiting elements
  ///
  /// Use when elements leave the screen (fade out, slide out).
  static const Curve accelerate = Curves.easeIn;

  /// Linear curve for progress indicators
  ///
  /// Use for progress bars, loading indicators, or uniform motion.
  static const Curve linear = Curves.linear;

  /// Bounce curve for playful interactions
  ///
  /// Use sparingly for playful, attention-grabbing animations.
  static const Curve bounce = Curves.bounceOut;

  /// Fast out, slow in curve (Material standard)
  ///
  /// Use for Material Design standard motion.
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
}
