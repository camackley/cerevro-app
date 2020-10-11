import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {

  String uid;
  bool      state;
  String    name;
  String    summary;
  String    miniature;
  String    duration;
  String    principalTag;
  int       likes;
  int       views;
  Timestamp creationDate;
  List<ExperienceArchive> archives;

  Experience.fromDocumentSnapshot(DocumentSnapshot data) {
    this.uid = data.documentID;
    this.state =data["state"];
    this.name =data["name"];
    this.summary =data["summary"];
    this.miniature =data["miniature"];
    this.duration =data["duration"];
    this.principalTag = data["principal_tag"];
    this.likes =data["likes"];
    this.creationDate = data["creation_date"];
    this.archives = _getArchive(data["archive"]);
    this.views =data["views"];
  }

  List<ExperienceArchive> _getArchive(Map data){
    List<ExperienceArchive> experiencesArchive = new List<ExperienceArchive>();
    
    data.forEach((key, value) {
      ExperienceArchive archive = new ExperienceArchive.fromMap(key, value);
      experiencesArchive.add(archive);
    });
    
    return experiencesArchive;
  }

}

class ExperienceArchive{
  String type;
  String urlFile;

  ExperienceArchive.fromMap(key, value){
    this.type = key;
    this.urlFile = value;
  }
}

class ResumeExperience{

  String title;
  int points;
  Timestamp date;

  ResumeExperience.fromDocumentSnapshot(DocumentSnapshot data){
    this.title = data["title"];
    this.date = Timestamp.fromMillisecondsSinceEpoch(data["date"]);
    this.points = data["points"];
  }

}
