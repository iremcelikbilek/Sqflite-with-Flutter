class PersonProject {
  int personID;
  int projectID;
  String personFullName;
  String projectName;

  PersonProject(this.personID, this.projectID);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['personID'] = this.personID;
    map['projectID'] = this.projectID;
    return map;
  }

  PersonProject.fromMap(Map<String, dynamic> map){
    this.personID = map['personID'];
    this.projectID = map['projectID'];
    this.personFullName = map['personFullName'];
    this.projectName = map['projectName'];
  }

}
