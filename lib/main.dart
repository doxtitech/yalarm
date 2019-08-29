import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'yAlarm'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addAlarm() {}

  @override
  Widget build(BuildContext context) {
    List<String> allAlarms = List<String>();
    allAlarms = ['Test 1', 'Test 2', 'test 3', 'another alarm', 'another alarm number 2'];
    List<Widget> allWidgetsAlarms = List<Widget>();
    allAlarms.forEach((item) {
      allWidgetsAlarms.add(
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(item),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: allWidgetsAlarms,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
