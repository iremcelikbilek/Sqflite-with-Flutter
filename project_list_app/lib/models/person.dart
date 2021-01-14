class Person{

  int personID;
  String personFullName;

  Person(this.personFullName);

  Person.withID(this.personID, this.personFullName);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['personID'] = this.personID;
    map['personFullName'] = this.personFullName;
    return map;
  }

  Person.fromMap(Map<String, dynamic> map){
    this.personID = map['personID'];
    this.personFullName = map['personFullName'];
  }
}