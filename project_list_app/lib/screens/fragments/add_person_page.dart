import 'package:flutter/material.dart';
import 'package:project_list_app/database/database_helper.dart';
import 'package:project_list_app/models/person.dart';

class AddPersonPage extends StatefulWidget {
  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {

  var formKey = GlobalKey<FormState>();
  DatabaseHelper databaseHelper;
  String personFullName;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      personFullName = text;
                    },
                    decoration: InputDecoration(
                      hintText: 'Ad Soyad giriniz',
                      labelText: 'Ad Soyad:',
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
                databaseHelper.addPerson(Person(personFullName)).then((personID) {
                  if(personID != 0){
                    debugPrint("personID değeri: $personID");
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Kayıt işlemi başarıyla gerçekleştirildi."),
                      action: SnackBarAction(
                        label: "Geri Al",
                        onPressed: (){
                          databaseHelper.deletePerson(personID).then((value){
                            if(value != 0){
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Kayıt geri alındı."),
                              ));
                            }
                          });
                        },
                      ),
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
    );
  }
}
