class UserModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  String? role;
  String? profileRef;
  String tokenDevice;
  String rangeAge;
  String gender;
  UserModel({
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.role,
    this.profileRef,
    required this.tokenDevice,
    required this.rangeAge,
    required this.gender,
  });

}
