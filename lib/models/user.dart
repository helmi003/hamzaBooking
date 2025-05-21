enum Rolemodel { user, admin, manager }

class UserModel {
  String uid;
  String organizationName;
  String firstName;
  String lastName;
  String email;
  Rolemodel role;

  UserModel(
    this.uid,
    this.organizationName,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['uid'] ?? '',
      json['organizationName'] ?? '',
      json['firstName'] ?? '',
      json['lastName'] ?? '',
      json['email'] ?? '',
      parseRolemodel(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'organizationName': organizationName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role.name,
    };
  }

  static Rolemodel parseRolemodel(String rolemodel) {
    switch (rolemodel) {
      case 'user':
        return Rolemodel.user;
      case 'manager':
        return Rolemodel.manager;
      case 'admin':
        return Rolemodel.admin;
      default:
        return Rolemodel.user;
    }
  }
}
