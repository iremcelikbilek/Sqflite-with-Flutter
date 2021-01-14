import 'package:flutter/material.dart';
import 'package:project_list_app/database/database_helper.dart';
import 'package:project_list_app/models/project.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddProjectPage> {

  var formKey = GlobalKey<FormState>();
  DatabaseHelper databaseHelper;
  String projectName;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (text){
                        if(text.length <= 0)
                          return "Lütfen ad soyad giriniz.";
                      },
                      onSaved: (text){
                        projectName = text;
                      },
                      decoration: InputDecoration(
                        hintText: 'Proje adı giriniz',
                        labelText: 'Proje Adı:',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            OutlineButton(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              onPressed: () {
                if(formKey.currentState.validate()){
                  formKey.currentState.save();
                  databaseHelper.addProject(Project(projectName)).then((projectID) {
                    if(projectID != 0){
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 500),
                        backgroundColor: Colors.black,
                        content: Text("Kayıt işlemi başarıyla gerçekleştirildi.",
                          style: TextStyle(color: Colors.white),),
                      ));
                    }
                  });
                }
              },
              child: Text(
                "KAYDET",
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
