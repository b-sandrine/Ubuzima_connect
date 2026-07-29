import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String id;
  final String? email;
  final String? displayName;
  final String? role;

  const AuthUserModel({
    required this.id,
    this.email,
    this.displayName,
    this.role,
  });

  factory AuthUserModel.fromFirebase(
    firebase.User user, {
    String? role,
  }) {
    return AuthUserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      role: role,
    );
  }

  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        displayName: displayName,
        role: role,
      );

  AuthUserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? role,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }
}
