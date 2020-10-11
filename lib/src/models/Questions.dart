class Questions{
  List<Options> options;
  String title;
  int index;

  Questions.fromJson(Map data){
    this.options = _getOptions(data["options"]);
    this.title = data["title"];
  }

  List<Options> _getOptions(List data){
    List<Options> options = new List<Options>();
    
    data.forEach((item) {
      Options archive = new Options.fromJson(item);
      options.add(archive);
    });
    
    return options;
  }
}

class Options{
  String title;
  bool isCorrect;

  Options.fromJson(Map data){
    this.title = data["title"];
    this.isCorrect = data["isCorrect"];
  }
}