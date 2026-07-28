import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String id;
  final String? email;
  final String? displayName;

  const AuthUserModel({
    required this.id,
    this.email,
    this.displayName,
  });

  factory AuthUserModel.fromFirebase(firebase.User user) {
    return AuthUserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        displayName: displayName,
      );
}
