import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalarm/alarmsProvider.dart';
import 'createAlarm.dart';

void main() => runApp(ChangeNotifierProvider(
    builder: (context) => AlarmsProvider(), child: MyApp()));

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
  //
  void _addAlarm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAlarm()));
    // setState(() {
    // Provider.of<AlarmsProvider>(context, listen: false).addAlarm('test2');
    // Provider.of<AlarmsProvider>(context, listen: false).updateAlarm('test1','test+++-1');
    // Provider.of<AlarmsProvider>(context, listen: false).removeAlarm('test3');
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AlarmsProvider>(context, listen: false).getLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> allWidgetsAlarms = List<Widget>();

    return Consumer<AlarmsProvider>(
      builder: (context, alarmsProviderItem, _) {
        List<String> localAlarms = alarmsProviderItem.alarms;
        localAlarms.forEach((item) {
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
              child: ListView.builder(
            itemCount: allWidgetsAlarms.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (BuildContext ctxt, int index) =>
                allWidgetsAlarms[index],
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: _addAlarm,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
