// import 'dart:developer';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlcrud/models/person_model.dart';
import 'package:sqlcrud/ui.dart';

// IN THIS LINE OF CODE, WE ARE BASICALLY OPENING UP THE DB AND CREATING THE NECESSARY TABLES
class PersonDB {
  final String dbName;
  Database? _db;
  List<Person> _persons = [];
  final _streamController = StreamController<List<Person>>.broadcast();

  PersonDB({required this.dbName});

  Future<List<Person>> _fetchPeople() async {
    //to read from the db, we must first confirm the data is not null
    final db = _db;
    if (db == null) {
      return [];
    }

    try {
      // excute a read querry
      final read = await db.query(
        "PEOPLE",
        distinct: true,
        columns: [
          'ID',
          'FIRST_NAME',
          'LAST_NAME',
        ],
        orderBy: 'ID',
      );

      final people = read.map((row) => Person.fromRow(row)).toList();
      return people;
    } catch (error) {
      print("Error fetching people = $error ");
      return [];
    }
  }

  Future<bool> open() async {
    if (_db != null) {
      true;
    }

    final directory = await getApplicationDocumentsDirectory();
    final dbPath = "${directory.path}/$dbName";
    try {
      final db = await openDatabase(dbPath);
      _db = db;

      //create table
      const creatTable = '''CREATE TABLE IF NOT EXISTS PEOPLE(
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      FIRST_NAME STRING NOT NULL,
      LAST_NAME STRING NOT NULL,
    )
    ''';

      await db.execute(creatTable);

      //read all the existing person objects from the database
      final persons = await _fetchPeople();
      // storing it inside our poeple array
      _persons = persons;
      //addin the persons to our stream
      _streamController.add(_persons);
      return true;
    } catch (error) {
      // print("$error");
      return false;
    }
  }

  Future<bool> close() async {
    final db = _db;
    if (db == null) {
      return false;
    }
    await db.close();
    return true;
  }

  Stream<List<Person>> all() =>
      _streamController.stream.map((persons) => persons..sort());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _crudStorage = PersonDB(dbName: 'db_sqlite');

  @override
  void initState() {
    _crudStorage.open();
    super.initState();
  }

  @override
  void dispose() {
    _crudStorage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Crud operations"),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Compose(),
            StreamBuilder(
              stream: _crudStorage.all(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Okay");
                } else if (snapshot.data == null || !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final people = snapshot.data as List<Person>;
                  // print(people);
                  return Expanded(
                    child: ListView.builder(
                        itemCount: people.length,
                        itemBuilder: (context, index) {
                          return const Text("hello");
                        }),
                  );
                }
              },
            ),
          ],
        ));
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: HomePage(),
  ));
}
