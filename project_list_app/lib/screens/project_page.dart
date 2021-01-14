import 'package:flutter/material.dart';
import 'package:project_list_app/database/database_helper.dart';
import 'package:project_list_app/models/person.dart';
import 'package:project_list_app/models/person_project.dart';
import 'package:project_list_app/models/project.dart';

class ProjectPage extends StatefulWidget {

  Project project;
  ProjectPage(this.project);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<ProjectPage> {

  DatabaseHelper databaseHelper;
  List<Person> allPerson;
  int personID;
  List<PersonProject> allPersonForProjectList;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    allPerson = List<Person>();
    allPersonForProjectList = List<PersonProject>();
    refreshList();
    databaseHelper.getPersonList().then((personList){
      if(personList != null){
        allPerson = personList;
        personID = allPerson[0].personID;
      }
    });

  }

  void refreshList() {
    databaseHelper.getPersonForProjectList(widget.project.projectID).then((personForProjectList) {
      if(personForProjectList != null){
        setState(() {
          allPersonForProjectList = personForProjectList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.project.projectName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              addProject(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              databaseHelper.deleteProject(widget.project.projectID).then((value){
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
      body: buildBody(context),
    );
  }

  void addProject(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context,setState){
              return SimpleDialog(
                title: Text("Kişi Ekle"),
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: createProjectItems(),
                        value: personID,
                        onChanged: (selectedPersonID) {
                          setState(() {
                            personID = selectedPersonID;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OutlineButton(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      onPressed: () {
                        databaseHelper.addPersonProject(PersonProject(personID,widget.project.projectID)).then((value) {
                          if(value != null){
                            refreshList();
                            Navigator.pop(context);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.black,
                                content: Text("Kayıt işlemi başarıyla gerçekleştirildi.",style: TextStyle(color: Colors.white,),
                                )));
                          }
                        });
                      },
                      child: Text("Kaydet"),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  List<DropdownMenuItem<int>> createProjectItems() {
    return allPerson.map((person) => DropdownMenuItem<int>(
      value: person.personID,
      child: Text(person.personFullName, style: TextStyle(color: Colors.white),),
    )).toList();
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: [
                DataColumn(label: Text("Person Id")),
                DataColumn(label: Text("Kişiler")),
                DataColumn(label: Text("İşlemler")),
              ],
              rows: getDataRows(context),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> getDataRows(BuildContext context) {
    var dataRows = List<DataRow>();
    for (int i = 0; i < allPersonForProjectList.length; i++) {
      dataRows.add(
          DataRow(cells: [
            DataCell(Text(allPersonForProjectList[i].personID.toString())),
            DataCell(Text(allPersonForProjectList[i].personFullName)),
            DataCell(
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      databaseHelper.deletePersonProject1(allPersonForProjectList[i].personID,widget.project.projectID).then((value){
                        refreshList();
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text("Silme işlemi başarıyla gerçekleştirildi.",style: TextStyle(color: Colors.white),),
                        ));
                      });
                    },
                  ),
                ],
              )
            ),
          ]));
    }
    return dataRows;
  }
}
