import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../datasources/local/role_selection_local_data_source.dart';
import '../../models/auth_user_model.dart';

abstract interface class FirebaseAuthRemoteDataSource {
  AuthUserModel? get currentUser;

  Stream<AuthUserModel?> get authStateChanges;

  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signInWithGoogle();

  Future<AuthUserModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> signOut();

  /// Reads `users/{uid}.role` from Firestore. Returns null when missing.
  Future<String?> fetchUserRole(String uid);
}

@LazySingleton(as: FirebaseAuthRemoteDataSource)
class FirebaseAuthRemoteDataSourceImpl implements FirebaseAuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final RoleSelectionLocalDataSource _roleSelectionLocalDataSource;

  FirebaseAuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore,
    this._roleSelectionLocalDataSource,
  );

  @override
  AuthUserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : AuthUserModel.fromFirebase(user);
  }

  @override
  Stream<AuthUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user == null ? null : AuthUserModel.fromFirebase(user);
    });
  }

  @override
  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim();
      if (normalizedEmail.isEmpty || password.isEmpty) {
        throw const AuthException('Email and password are required.');
      }

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Sign in failed. Please try again.');
      }
      final role = await _ensureUserProfile(user);
      return AuthUserModel.fromFirebase(user, role: role);
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (_) {
      throw const AuthException(
        'Unable to sign in right now. Please try again.',
      );
    }
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) {
        throw const AuthException('Google sign-in failed. Please try again.');
      }
      final role = await _ensureUserProfile(user);
      return AuthUserModel.fromFirebase(user, role: role);
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<AuthUserModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Registration failed. Please try again.');
      }
      await user.updateDisplayName(displayName.trim());
      final resolvedRole = await _ensureUserProfile(
        user,
        overrideDisplayName: displayName.trim(),
        overrideEmail: email.trim(),
        preferredRole: role,
      );
      await user.reload();
      return AuthUserModel.fromFirebase(
        _firebaseAuth.currentUser ?? user,
        role: resolvedRole,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<String?> fetchUserRole(String uid) async {
    try {
      final snapshot =
          await _firestore.collection(FirestorePaths.users).doc(uid).get();
      final role = snapshot.data()?['role'] as String?;
      if (role != null && role.isNotEmpty && role != 'unknown') {
        await _roleSelectionLocalDataSource.cacheSelectedRole(role);
      }
      return role;
    } on FirebaseException {
      return null;
    }
  }

  String _messageFor(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' ||
      'invalid-login-credentials' =>
        'Incorrect email or password.',
      'invalid-email' => 'Enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' => 'No internet connection.',
      _ => e.message ?? 'Authentication failed.',
    };
  }

  /// Ensures `users/{uid}` exists and returns the resolved role storage value.
  Future<String> _ensureUserProfile(
    User user, {
    String? overrideDisplayName,
    String? overrideEmail,
    String? preferredRole,
  }) async {
    final selectedRole = _roleSelectionLocalDataSource.readSelectedRole();
    final fallbackRole = preferredRole ?? selectedRole ?? 'unknown';
    final docRef = _firestore.collection(FirestorePaths.users).doc(user.uid);

    try {
      final snapshot = await docRef.get();
      final data = snapshot.data();
      final existingRole = data?['role'] as String?;

      if (!snapshot.exists) {
        await docRef.set({
          'uid': user.uid,
          'displayName': overrideDisplayName ?? user.displayName ?? '',
          'email': overrideEmail ?? user.email ?? '',
          'role': fallbackRole,
          'ownerId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (fallbackRole != 'unknown') {
          await _roleSelectionLocalDataSource.cacheSelectedRole(fallbackRole);
        }
        return fallbackRole;
      }

      final updates = <String, Object?>{};
      final resolvedDisplayName = overrideDisplayName ?? user.displayName;
      final resolvedEmail = overrideEmail ?? user.email;
      if (resolvedDisplayName != null &&
          resolvedDisplayName.isNotEmpty &&
          (data?['displayName'] as String?)?.isEmpty != false) {
        updates['displayName'] = resolvedDisplayName;
      }
      if (resolvedEmail != null &&
          resolvedEmail.isNotEmpty &&
          (data?['email'] as String?)?.isEmpty != false) {
        updates['email'] = resolvedEmail;
      }

      var resolvedRole = existingRole ?? '';
      if (existingRole == null ||
          existingRole.isEmpty ||
          existingRole == 'unknown') {
        updates['role'] = fallbackRole;
        resolvedRole = fallbackRole;
      }

      if (updates.isNotEmpty) {
        await docRef.update(updates);
      }

      if (resolvedRole.isNotEmpty && resolvedRole != 'unknown') {
        await _roleSelectionLocalDataSource.cacheSelectedRole(resolvedRole);
      }

      return resolvedRole.isEmpty ? fallbackRole : resolvedRole;
    } on FirebaseException catch (_) {
      await _firebaseAuth.signOut();
      throw const AuthException(
        'Signed in, but failed to create your profile. Please try again.',
      );
    }
  }
}
