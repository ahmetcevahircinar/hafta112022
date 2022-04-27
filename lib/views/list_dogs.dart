import "package:flutter/material.dart";
import 'package:hafta112022/main.dart';
import 'package:hafta112022/models/Dog.dart';
import 'package:hafta112022/services/db_utils.dart';

DbUtils utils = DbUtils();

class ListDogs extends StatefulWidget {
  @override
  _ListDogsState createState() => _ListDogsState();
}

class _ListDogsState extends State<ListDogs> {
  List<Dog> dogList = [];

  void getData() async {
    await utils.dogs().then((result) => {
          setState(() {
            dogList = result;
          })
        });
    print(dogList);
  }

  void showAlert(String alertTitle, String alertContent) {
    AlertDialog alertDialog;
    alertDialog =
        AlertDialog(title: Text(alertTitle), content: Text(alertContent));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dogList.length.toString() + " Dogs listed")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dogList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dogList[index].name),
                    onTap: () {
                      showAlert("Dog " + index.toString() + " clicked",
                          "Dog " + index.toString() + " clicked");
                    },
                    onLongPress: () async {
                      await utils.deleteDog(dogList[index].id).then((value) => {
                            showAlert("Dog " + index.toString() + " deleted",
                                "Dog " + index.toString() + " deleted")
                          });
                      getData();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: Text("Return Homepage")),
            ),
          ],
        ),
      ),
    );
  }
}
