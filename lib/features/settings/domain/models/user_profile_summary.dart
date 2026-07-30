import 'package:flutter/material.dart';

/// The identity strip at the top of Settings — reused by both the doctor
/// and patient audience since the card shape is identical, only the role
/// label/facility/colour differ.
class UserProfileSummary {
  final String fullName;
  final String roleLabel;
  final String facility;
  final String displayId;
  final String? photoUrl;
  final bool isActive;
  final Color accentColor;

  const UserProfileSummary({
    required this.fullName,
    required this.roleLabel,
    required this.facility,
    required this.displayId,
    required this.accentColor,
    this.photoUrl,
    this.isActive = true,
  });
}
