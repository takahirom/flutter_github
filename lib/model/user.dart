class User {
  User({this.login, this.name});

  String login;
  String name;

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(login: json["login"], name: json["name"]);
  }
}
