import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalarm/Alarms.dart';
import 'alarmsProvider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:day_selector/day_selector.dart';

class CreateAlarm extends StatefulWidget {
  YAlarms item;
  CreateAlarm({Key key, this.item}) : super(key: key);
  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  String alarmName;
  String selectedTime = '';
  DateTime alarmTime;
  bool onlyOnce = false;
  String _dynamicText = 'Add Alarm';
  TextEditingController alarmController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alarmName = widget.item != null && widget.item.title != null
        ? widget.item.title
        : '';
    if (widget.item != null && widget.item.title != null) {
      alarmController = new TextEditingController(text: widget.item.title);
      alarmTime = widget.item.time;
      selectedTime =
          '${alarmTime.hour}:${alarmTime.minute}:${alarmTime.second}';
      onlyOnce = widget.item.runOnlyOnce;
    }
    if (widget.item != null) {
      _dynamicText = 'Update Alarm';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmsProvider>(
        builder: (context, alarmsProviderItemLink, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_dynamicText),
          actions: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: InkWell(
                child: Icon(Icons.delete),
                onTap: () {
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Remove Alarm?'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('The alarm will be removed for ever!'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              alarmsProviderItemLink.removeAlarm(alarmName);
                              // Navigator.of(context).pop();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                onChanged: (newValue) {
                  alarmName = newValue;
                  alarmController = new TextEditingController(text: alarmName);
                },
                decoration: InputDecoration(hintText: 'Enter a alarm Name'),
                controller: alarmController,
              ),
              Row(children: [
                FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change ${date.hour} in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                      setState(() {
                        alarmTime = date;
                        selectedTime =
                            '${alarmTime.hour}:${alarmTime.minute}:${alarmTime.second}';
                        print('Time is ${alarmTime.hour}');
                      });
                    }, onConfirm: (date) {
                      print('confirm $date');
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    'Select a time',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '${selectedTime}',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ]),
              DaySelector(
                  value: null,
                  onChange: (value) {
                    print(DaySelector.monday == value);
                  },
                  color: Colors.white,
                  mode: DaySelector.modeFull),
              Row(children: [
                new Switch(
                  value: onlyOnce,
                  onChanged: (val) {
                    setState(() {
                      onlyOnce = !onlyOnce;
                    });
                    //
                  },
                ),
                Text('Run Only once')
              ]),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 100.0,
          width: 100.0,
          child: FittedBox(
            child: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: Text(
                  _dynamicText,
                  style: TextStyle(fontSize: 10.0),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  YAlarms newAlarm = new YAlarms();
                  newAlarm.title = alarmName;
                  newAlarm.time = alarmTime;
                  newAlarm.runOnlyOnce = onlyOnce;

                  Provider.of<AlarmsProvider>(context, listen: false)
                      .addAlarm(newAlarm);
                  Navigator.pop(context);
                }),
          ),
        ),
      );
    });
  }
}
