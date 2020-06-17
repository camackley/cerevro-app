class User {

  dynamic uid;
  dynamic email;
  dynamic age;
  dynamic name;
  dynamic phone;
  dynamic topics;

  User.fromJson(Map data) {
    this.uid = data["uid"];
    this.email = data["email"];
    this.age=data["age"];
    this.name=data["name"];
    this.phone=data["phone"];
    this.topics=data["topics"];
  }

  User(){}
}