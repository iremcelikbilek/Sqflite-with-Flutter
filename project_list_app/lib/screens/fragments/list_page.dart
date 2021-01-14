import 'package:flutter/material.dart';
import 'package:project_list_app/database/database_helper.dart';
import 'package:project_list_app/models/person.dart';
import 'package:project_list_app/models/project.dart';
import 'package:project_list_app/screens/person_page.dart';
import 'package:project_list_app/screens/project_page.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DatabaseHelper databaseHelper;
  List<Person> allPersons;
  List<Project> allProject;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    allPersons = List<Person>();
    allProject = List<Project>();
    refreshList();
    debugPrint("init state çalıştı");
  }

  @override
  Widget build(BuildContext context) {
    //refreshList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.deepOrange,
          //expandedHeight: 200,
          floating: false,
          pinned: true,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Kişi Listesi"),
            centerTitle: true,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(createPersonList,
                childCount: allPersons.length),
          ),
        ),
        SliverAppBar(
          //title: Text("Proje Listesi"),
          backgroundColor: Colors.deepOrange,
          //expandedHeight: 200,
          floating: false,
          pinned: true,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Proje Listesi"),
            centerTitle: true,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(createProjectList,
                childCount: allProject.length),
          ),
        ),
      ],
    );
  }

  Widget createPersonList(BuildContext context, int index) {
    return ListTile(
      title: Text(allPersons[index].personFullName),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => PersonPage(allPersons[index])))
            .then((value) {
          refreshList();
        });
      },
    );
  }

  Widget createProjectList(BuildContext context, int index) {
    return ListTile(
      title: Text(allProject[index].projectName),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ProjectPage(allProject[index])))
            .then((value) {
          refreshList();
        });
      },
    );
  }

  void refreshList() {
    databaseHelper.getPersonList().then((personList) {
      if (personList != null) {
        setState(() {
          debugPrint("person list state çalıştı");
          allPersons = personList;
        });
      }
    });
    databaseHelper.getProjectList().then((projectList) {
      if (projectList != null) {
        //debugPrint("Project DB metodu çalıştı.");
        //allProject = projectList;
        setState(() {
          debugPrint("project list state çalıştı");
          allProject = projectList;
        });
      }
    });
  }
}
