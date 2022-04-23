class UserModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  String? role;
  String? profileRef;
  String tokenDevice;

  UserModel({
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.role,
    this.profileRef,
    required this.tokenDevice,
  });

}
