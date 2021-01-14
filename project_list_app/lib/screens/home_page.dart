import 'package:flutter/material.dart';
import 'package:project_list_app/screens/fragments/add_person_page.dart';
import 'package:project_list_app/screens/fragments/add_project_page.dart';
import 'package:project_list_app/screens/fragments/list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedNavBarItem = 1;
  List<Widget> allFragments;
  AddPersonPage personPage;
  AddProjectPage projectPage;
  ListPage listPage;

  @override
  void initState() {
    super.initState();
    personPage = AddPersonPage();
    projectPage = AddProjectPage();
    listPage = ListPage();
    allFragments = [personPage,listPage,projectPage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Text("Project App"),
        ),
      ),
      body: allFragments[selectedNavBarItem],

      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.deepOrange
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.2),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            title: Text("Kişi Ekle"),
          ),
         BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Ana Sayfa"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            title: Text("Proje Ekle"),
          ),
        ],
        currentIndex: selectedNavBarItem,
        onTap: (index){
          setState(() {
            selectedNavBarItem = index;
          });
        },
      ),
    );
  }


}
