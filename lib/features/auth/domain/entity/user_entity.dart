class AuthEntity {
  final String id;
  final String username;
  final String fullName;
  final String gender;
  final String profilePic;
  final String token; 

  const AuthEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.profilePic,
    required this.token,
  });
}
