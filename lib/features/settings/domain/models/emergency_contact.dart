import 'package:flutter/material.dart';

/// One entry in the Settings screen's Emergency Contacts list.
class EmergencyContact {
  final String id;
  final String name;
  final String relationship;
  final String phoneNumber;
  final IconData icon;
  final Color iconColor;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    required this.icon,
    required this.iconColor,
  });
}
