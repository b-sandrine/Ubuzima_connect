class AuthUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? role;

  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.role,
  });
}
