class AppUser {
  final String uid;
  final String email;
  final String role;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  factory AppUser.fromFirestore(
      Map<String, dynamic> data, String id) {
    return AppUser(
      uid: id,
      email: data['email'],
      role: data['role'],
    );
  }
}
