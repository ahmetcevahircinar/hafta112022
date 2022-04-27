import "package:flutter/material.dart";
import 'package:hafta112022/views/list_dogs.dart';
import 'package:sqflite/sqflite.dart';
import 'models/Dog.dart';
import 'package:hafta112022/services/db_utils.dart';

DbUtils utils = DbUtils();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqlite Örneği',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController kopekIdController = TextEditingController();
  TextEditingController kopekAdController = TextEditingController();
  TextEditingController kopekYasController = TextEditingController();

  late Future<Database> database;

  List<Dog> dogList = [];

  _onPressedUpdate() async {
    final enik = Dog(
      id: int.parse(kopekIdController.text),
      name: kopekAdController.text,
      age: int.parse(kopekYasController.text),
    );
    utils.updateDog(enik);
    dogList = await utils.dogs();
    //print(dogList);
    getData();
  }

  _onPressedAdd() async {
    final enik = Dog(
      id: int.parse(kopekIdController.text),
      name: kopekAdController.text,
      age: int.parse(kopekYasController.text),
    );
    utils.insertDog(enik);
    dogList = await utils.dogs();
    //print(dogList);
    getData();
  }

  _deleteDogTable() {
    utils.deleteTable();
    dogList = [];
    getData();
  }

  void getData() async {
    await utils.dogs().then((result) => {
          setState(() {
            dogList = result;
          })
        });
    print(dogList);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqlite Örneği',
      home: Scaffold(
        appBar: AppBar(title: const Text("Sqlite Örneği")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: kopekIdController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter ID'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: kopekAdController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Name'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: kopekYasController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Age'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _onPressedAdd, child: Text("Insert Dog")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _onPressedUpdate, child: Text("Update Dog")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _deleteDogTable,
                    child: const Text("Delete Dog Table")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListDogs()),
                      );
                    },
                    child: Text("List Dogs")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      getData();
                    },
                    child: Text("Refresh List")),
              ),
              Text(dogList.length.toString()),
              SingleChildScrollView(
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
