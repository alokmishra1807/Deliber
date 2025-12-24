class UserEntity {
  final String id;
  final String? email;
  final String? name;
  final String? avatar;

  const UserEntity({
    required this.id,
    this.email,
    this.name,
    this.avatar,
  });
}
