class Experience {

  dynamic image;
  dynamic resume;
  dynamic title;
  dynamic url;
  dynamic uid;

  Experience.fromJson(Map data) {
    this.image=data["uid"];
    this.image=data["image"];
    this.resume=data["resume"];
    this.url=data["url"];
    this.title=data["title"];
  }
}