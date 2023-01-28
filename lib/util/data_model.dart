class DataModel {
  int? id;
  String firstname;
  String lastname;
  String username;
  String password;
  String email;

  DataModel({this.id, required this.firstname, required this.lastname, required this.username, required this.password, required this.email});

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
      id: json['id'], firstname: json["firstname"], lastname: json["lastname"], username: json["username"], password: json["password"], email: json["email"]);

  Map<String, dynamic> toMap() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "password": password,
    "email":  email,
  };


  factory DataModel.fromJson(Map<dynamic, dynamic> json) {
    return DataModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
    );
  }
}
