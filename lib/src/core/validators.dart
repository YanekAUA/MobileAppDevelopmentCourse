// lib/src/core/validators.dart
// Pure helpers for parsing, clamping and validation used by UI and business logic.
// Designed to provide two families of functions:
//  - Form validators: (String?) -> String? (null = valid) for TextFormField.validator
//  - Typed helpers: pure functions that operate on numbers/lists for presenter/usecase logic

import 'dart:math' as math;

/// Tries to parse a [String] into a [double]. Returns null when parsing fails
/// or the input is null/empty.
double? tryParseDouble(String? s) {
  if (s == null) return null;
  final trimmed = s.trim();
  if (trimmed.isEmpty) return null;
  final parsed = double.tryParse(trimmed);
  if (parsed != null) return parsed;
  // Support comma decimal separators (e.g. "12,5") often used in some locales.
  final alt = trimmed.replaceAll(',', '.');
  return double.tryParse(alt);
}

/// Parses [s] and returns [defaultValue] when parsing fails or input is null/empty.
double parseDoubleOrDefault(String? s, double defaultValue) {
  return tryParseDouble(s) ?? defaultValue;
}

/// Flutter form-style validator that enforces a non-empty value.
String? requiredFieldValidator(String? value, {String message = 'Required'}) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}

/// Flutter-friendly validator for numeric fields.
/// Returns null when valid, otherwise returns an error message.
String? numberFieldValidator(
  String? value, {
  double min = 0,
  double max = 100,
  String? emptyMessage,
  String? rangeMessage,
  bool allowEmpty = false,
}) {
  if (value == null || value.trim().isEmpty) {
    return allowEmpty ? null : (emptyMessage ?? 'Required');
  }
  final parsed = tryParseDouble(value);
  if (parsed == null) return 'Must be a number';
  if (parsed.isNaN) return 'Invalid number';
  if (parsed < min || parsed > max) {
    return rangeMessage ?? 'Value must be between $min and $max';
  }
  return null;
}

/// Validator specialized for percentage inputs (0..100).
String? percentageFieldValidator(String? value, {bool allowEmpty = false}) {
  return numberFieldValidator(value, min: 0, max: 100, allowEmpty: allowEmpty);
}

/// Clamp a double value to [min..max].
double clampDouble(double value, double min, double max) =>
    value < min ? min : (value > max ? max : value);

/// Round [value] to [decimals] decimal places.
double roundTo(double value, int decimals) {
  if (decimals <= 0) return value.roundToDouble();
  final factor = math.pow(10, decimals).toDouble();
  return (value * factor).round() / factor;
}

/// Clamp then round to [decimals] places.
double clampAndRound(double value, double min, double max, int decimals) {
  final clamped = clampDouble(value, min, max);
  return roundTo(clamped, decimals);
}

/// Normalize a list of homework grades to an exact length [expectedSlots].
///
/// - If an input slot is null or missing, it is replaced with 0.0 when
///   [treatMissingAsZero] is true. If false, missing entries are treated as 0.0
///   as well (callers can detect original length if they need to).
List<double> normalizeHomeworkList(
  List<double?> input, {
  required int expectedSlots,
  bool treatMissingAsZero = true,
  double clampMin = 0,
  double clampMax = 100,
}) {
  final out = List<double>.filled(expectedSlots, 0.0, growable: false);
  for (int i = 0; i < expectedSlots; i++) {
    final v = (i < input.length ? input[i] : null);
    if (v == null) {
      out[i] = treatMissingAsZero ? 0.0 : 0.0;
    } else {
      out[i] = clampDouble(v, clampMin, clampMax);
    }
  }
  return out;
}

/// Validates a list of homework grades. Returns null on success or an error message.
String? validateHomeworkList(
  List<double?> input, {
  required int expectedSlots,
  double min = 0,
  double max = 100,
  bool allowFewer = false,
}) {
  if (!allowFewer && input.length != expectedSlots) {
    return 'Expected $expectedSlots homework grades';
  }
  for (final v in input) {
    if (v == null) return 'All homework grades must be provided';
    if (v.isNaN) return 'Invalid homework grade';
    if (v < min || v > max) {
      return 'Homework grades must be between $min and $max';
    }
  }
  return null;
}

/// Validates that a map of weights sums to [expectedTotal] within a small epsilon.
String? validateWeightsSum(
  Map<String, double> weights, {
  double expectedTotal = 100,
}) {
  final sum = weights.values.fold(0.0, (a, b) => a + b);
  if ((sum - expectedTotal).abs() > 1e-6) {
    return 'Weights must sum to $expectedTotal (got ${sum.toStringAsFixed(2)})';
  }
  return null;
}
