import 'dart:io';

import 'package:flutter/services.dart';
import 'package:project_list_app/models/person.dart';
import 'package:project_list_app/models/person_project.dart';
import 'package:project_list_app/models/project.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    //Eğer constructor'da return ifadesi döndüreceksem bunu factory ile yapabilirim.
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      //Singleton tasarım kalıbı. Tek nesne üretmek için kullanılır.
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal(); // İsimlendirilmiş Constructor

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "multipleDB.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "multipleDB.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> getPerson() async{
    var db = await _getDatabase();
    var result = await db.query("person");
    return result;
  }

  Future<List<Person>> getPersonList() async{
    var personMapList = await getPerson();
    var personList = List<Person>();
    for(Map map in personMapList){
      personList.add(Person.fromMap(map));
    }
    return personList;
  }

  Future<int> addPerson(Person person) async{
    var db = await _getDatabase();
    var result = await db.insert("person", person.toMap());
    return result;
  }

  Future<int> updatePerson(Person person) async{
    var db = await _getDatabase();
    var result = await db.update("person", person.toMap(),where: 'personID = ?',whereArgs: [person.personID]);
    return result;
  }

  Future<int> deletePerson(int personID) async{
    var db = await _getDatabase();
    var result = await db.delete("person", where: 'personID = ?', whereArgs: [personID]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getProject() async {
    var db = await _getDatabase();
    var result = await db.query("project");
    return result;
  }

  Future<List<Project>> getProjectList() async {
    var projectMapList = await getProject();
    var projectList = List<Project>();
    for(Map map in projectMapList){
      projectList.add(Project.fromMap(map));
    }
    return projectList;
  }

  Future<int> addProject(Project project) async{
    var db = await _getDatabase();
    var result = await db.insert("project", project.toMap());
    return result;
  }

  Future<int> updateProject(Project project) async{
    var db = await _getDatabase();
    var result = await db.update("project", project.toMap(), where: 'projectID = ?', whereArgs: [project.projectID]);
    return result;
  }

  Future<int> deleteProject(int projectID) async{
    var db = await _getDatabase();
    var result = await db.delete("project", where: 'projectID = ?', whereArgs: [projectID]);
    //db.rawDelete("delete from project where projectID = $projectID");
    return result;
  }


  Future<int> addPersonProject(PersonProject personProject) async{
    var db = await _getDatabase();
    var result = await db.insert("person_project", personProject.toMap());
    return result;
  }

  Future<int> deletePersonProject1(int personID,int projectID) async{
    var db = await _getDatabase();
    var result = await db.rawDelete("delete from person_project where personID = $personID and projectID = $projectID");
    return result;
  }

  Future<List<Map<String, dynamic>>> getProjectForPerson(int personID) async{
    var db = await _getDatabase();
    var result = await db.rawQuery("select project.projectID, project.projectName from person inner join person_project "
        "on person.personID = person_project.personID "
        "inner join project on project.projectID = person_project.projectID where person_project.personID = $personID");
    return result;
  }

  Future<List<PersonProject>> getProjectForPersonList(int personID) async{
    var projectForPersonMapList = await getProjectForPerson(personID);
    var projectForPersonList = List<PersonProject>();
    for(Map map in projectForPersonMapList){
      projectForPersonList.add(PersonProject.fromMap(map));
    }
    return projectForPersonList;
  }

  Future<List<Map<String, dynamic>>> getPersonForProject(int projectID) async{
    var db = await _getDatabase();
    var result = await db.rawQuery("select person.personID,person.personFullName from person inner join person_project "
        "on person.personID = person_project.personID "
        "inner join project on project.projectID = person_project.projectID where person_project.projectID = $projectID");
    return result;
  }

  Future<List<PersonProject>> getPersonForProjectList(int projectID) async{
    var personForProjectMapList = await getPersonForProject(projectID);
    var personForProjectList = List<PersonProject>();
    for(Map map in personForProjectMapList){
      personForProjectList.add(PersonProject.fromMap(map));
    }
    return personForProjectList;
  }

}
