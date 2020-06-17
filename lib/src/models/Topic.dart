class Topic {

  dynamic uid;
  List experiencias;
  dynamic image;
  dynamic resume;
  dynamic stars;
  dynamic title;

  Topic.fromJson(Map data) {
    this.experiencias=data["experiences"];
    this.uid=data["uid"];
    this.image=data["image"];
    this.resume=data["resume"];
    this.stars=data["stars"];
    this.title=data["title"];
  }
}