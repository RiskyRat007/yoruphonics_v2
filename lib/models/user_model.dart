class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? role; // 👈 make nullable

  UserModel({required this.uid, required this.email, this.name, this.role});

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'],
      role: data['role'], // no default
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role};
  }
}
