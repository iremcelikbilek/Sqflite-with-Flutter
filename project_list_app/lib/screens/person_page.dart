import 'package:flutter/material.dart';
import 'package:project_list_app/database/database_helper.dart';
import 'package:project_list_app/models/person.dart';
import 'package:project_list_app/models/person_project.dart';
import 'package:project_list_app/models/project.dart';

class PersonPage extends StatefulWidget {

  Person person;
  PersonPage(this.person);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {


  DatabaseHelper databaseHelper;
  List<Project> allProjects;
  int projectID;
  List<PersonProject> allProjectForPersonList;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    allProjects = List<Project>();
    allProjectForPersonList = List<PersonProject>();
    refreshList();
    databaseHelper.getProjectList().then((projectList){
      if(projectList != null){
         allProjects = projectList;
          projectID = allProjects[0].projectID;
      }
    });

  }

  void refreshList() {
    databaseHelper.getProjectForPersonList(widget.person.personID).then((projectForPersonList) {
      if(projectForPersonList != null){
       setState(() {
         allProjectForPersonList = projectForPersonList;
       });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.person.personFullName),
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
              databaseHelper.deletePerson(widget.person.personID).then((value){
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
                title: Text("Proje Ekle"),
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
                        value: projectID,
                        onChanged: (selectedProjectID) {
                          setState(() {
                            projectID = selectedProjectID;
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
                        databaseHelper.addPersonProject(PersonProject(widget.person.personID,projectID)).then((value) {
                          if(value != null){
                            debugPrint("value değeri : $value");
                            refreshList();
                            Navigator.pop(context);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.black,
                                content: Text("Kayıt işlemi başarıyla gerçekleştirildi.",style: TextStyle(color: Colors.white,),
                                )));
                          }
                        });
                      },

                      child: Text(
                        "Kaydet",
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  List<DropdownMenuItem<int>> createProjectItems() {
    return allProjects.map((project) => DropdownMenuItem<int>(
      value: project.projectID,
      child: Text(project.projectName, style: TextStyle(color: Colors.white),),
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
                DataColumn(label: Text("Project Id")),
                DataColumn(label: Text("Projeler")),
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
    for (int i = 0; i < allProjectForPersonList.length; i++) {
      dataRows.add(
          DataRow(cells: [
            DataCell(
                Text(allProjectForPersonList[i].projectID.toString()),
            ),
            DataCell(Text(allProjectForPersonList[i].projectName)),
            DataCell(
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        databaseHelper.deletePersonProject1(widget.person.personID,allProjectForPersonList[i].projectID).then((value){
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
