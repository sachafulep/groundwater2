class SimpleUser {
  final int id;
  String name;

  SimpleUser({this.id, this.name});

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(id: int.tryParse(json["id"].toString()), name: json["name"].toString());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return "SimpleUser{id: $id, name: $name}";
  }
}
