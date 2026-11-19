class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? verificationStatus;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.verificationStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final driverDetails = json['driverDetails'];

    return UserModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'passenger',
      verificationStatus: driverDetails is Map
          ? driverDetails['verificationStatus']?.toString()
          : null,
    );
  }
}