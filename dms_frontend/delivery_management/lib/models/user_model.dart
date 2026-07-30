class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final int? roleId;
  final String? roleName;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.roleId,
    this.roleName,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['full_name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      roleId: json['role_id'],
      roleName: json['role_name'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'phone': phone,
      'role_id': roleId,
      'role_name': roleName,
      'profile_image': profileImage,
    };
  }
}
