class Profile {
  int? code;

  bool? status;
  String? nama;
  String? email;

  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  Profile({this.code, this.status, this.nama, this.email});
  Profile.lengkap({this.code, this.status, this.nama, this.email, this.currentPassword, this.newPassword, this.confirmPassword});

  factory Profile.fromJson(Map<String, dynamic> obj) {
    return Profile(
      code: obj['code'],
      status: obj['status'],
      nama: obj['data']['nama'],
      email: obj['data']['email']
    );
  }
}
