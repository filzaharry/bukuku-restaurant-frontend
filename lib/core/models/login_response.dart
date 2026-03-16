class LoginData {
  final String? nextStep;

  LoginData({this.nextStep});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      nextStep: json['next_step'],
    );
  }
}
