import 'package:flutter/material.dart';

/// One translucent chip on the records header card — blood type, an
/// allergy, or a chronic condition summary.
class PatientTag {
  final IconData icon;
  final String label;

  const PatientTag({required this.icon, required this.label});
}
