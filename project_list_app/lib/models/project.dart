class Project{

  int projectID;
  String projectName;

  Project(this.projectName);

  Project.withID(this.projectID, this.projectName);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['projectID'] = this.projectID;
    map['projectName'] = this.projectName;
    return map;
  }

  Project.fromMap(Map<String, dynamic> map){
    this.projectID = map['projectID'];
    this.projectName = map['projectName'];
  }
}