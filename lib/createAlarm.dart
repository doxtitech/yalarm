import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'alarmsProvider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateAlarm extends StatefulWidget {
  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  String alarmName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Alarm'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (newValue) {
              alarmName = newValue;
            },
            decoration: InputDecoration(hintText: 'Enter a alarm Name'),
          ),
          FlatButton(
              onPressed: () {
                DatePicker.showTimePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    print('confirm $date');
                  }, currentTime: DateTime.now());
              },
              child: Text(
                'Select a time',
                style: TextStyle(color: Colors.blue),
              )),
          RaisedButton(
            child: Text('Add Alarm'),
            onPressed: () {
              Provider.of<AlarmsProvider>(context, listen: false)
                  .addAlarm(alarmName);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
