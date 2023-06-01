class UserToken {
  final String token;
  final String uid;
  final String email;

  UserToken({
    required this.token,
    required this.uid,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'uid': uid,
        'email': email,
      };

  static UserToken fromJson(Map<String, dynamic> json) => UserToken(
        token: json['token'],
        uid: json['uid'],
        email: json['email'],
      );
}
