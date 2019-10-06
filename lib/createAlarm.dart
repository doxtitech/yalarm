import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalarm/Alarms.dart';
import 'alarmsProvider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'yAlarmDayPicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:youtube_player/youtube_player.dart';

class CreateAlarm extends StatefulWidget {
  YAlarms item;
  CreateAlarm({Key key, this.item}) : super(key: key);
  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  int alarmID;
  String alarmName;
  String selectedTime = '';
  DateTime alarmTime;
  bool onlyOnce = true;
  String _dynamicText = 'Add Alarm';
  TextEditingController alarmController;
  List<int> selectedDaysOfWeek = [0, 0, 0, 0, 0, 0, 0];
  bool isEnabled;
  String youtubeSource;
  StreamSubscription _intentDataStreamSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alarmID =
        widget.item != null && widget.item.id != null ? widget.item.id : 0;
    selectedDaysOfWeek = widget.item != null && widget.item.daySelector != null
        ? widget.item.daySelector
        : selectedDaysOfWeek;
    if (widget.item != null && widget.item.title != null) {
      alarmName = widget.item.title;
      alarmController = new TextEditingController(text: alarmName);
      alarmTime = widget.item.time;
      isEnabled = widget.item.isEnabled;
      youtubeSource = widget.item.youtubeSource;
      if (alarmTime != null) {
        selectedTime =
            '${alarmTime.hour}:${alarmTime.minute}:${alarmTime.second}';
      }

      onlyOnce = widget.item.runOnlyOnce;
    } else {
      alarmController = new TextEditingController();
    }
    if (widget.item != null) {
      _dynamicText = 'Update Alarm';
    }

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      List<String> tempListSource = value.split('/');
      youtubeSource = tempListSource[tempListSource.length - 1];
      setState(() {
        //just rebuild
      });
    }, onError: (err) {
      print('error: $err');
    });
  }

  List<int> getDays(widgetDays) {
    selectedDaysOfWeek = widgetDays;
  }

  void _goToYoutube() async {
    String youtubePath = 'https://www.youtube.com';
    if (await canLaunch(youtubePath)) {
      await launch(youtubePath);
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
            widget.item != null
                ? Padding(
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
                                    alarmsProviderItemLink.removeAlarm(alarmID);
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
                : Container()
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
              Row(
                children: <Widget>[
                  Switch(
                    value: isEnabled != true ? false : true,
                    onChanged: (newVal) {
                      if (widget.item != null) {
                        YAlarms newAlarm = widget.item;
                        newAlarm.isEnabled = newVal;
                        alarmsProviderItemLink.updateAlarm(
                            widget.item, newAlarm);
                      }
                      setState(() {
                        isEnabled = newVal;
                      });
                    },
                  ),
                  Text('Alarm ${isEnabled == true ? 'Enabled' : 'Disabled'}')
                ],
              ),
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
              Row(children: [
                FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      setState(() {
                        alarmTime = date;
                        if (alarmTime != null) {
                          selectedTime =
                              '${alarmTime.hour}:${alarmTime.minute}:${alarmTime.second}';
                        }
                      });
                    }, onConfirm: (date) {}, currentTime: DateTime.now());
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
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  youtubeSource = null;
                  _goToYoutube();
                },
                child: Text(
                  'Select a Video',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // custom day selector here

              onlyOnce == false
                  ? YADayPicker(
                      selectedDays: selectedDaysOfWeek,
                      getDayPickerDays: getDays,
                    )
                  : Container(),
              youtubeSource != null
                  ? YoutubePlayer(
                      context: context,
                      source: youtubeSource,
                      quality: YoutubeQuality.HD,
                      autoPlay: false,
                    )
                  : Container()
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
                  alarmName = alarmController.text;
                  YAlarms newAlarm = new YAlarms();
                  newAlarm.id = alarmID;
                  newAlarm.title = alarmName;
                  newAlarm.time = alarmTime;
                  newAlarm.runOnlyOnce = onlyOnce;
                  newAlarm.daySelector = selectedDaysOfWeek;
                  newAlarm.isEnabled = isEnabled;
                  newAlarm.youtubeSource = youtubeSource;
                  if (widget.item != null) {
                    YAlarms oldAlarm = widget.item;
                    Provider.of<AlarmsProvider>(context, listen: false)
                        .updateAlarm(oldAlarm, newAlarm);
                  } else {
                    Provider.of<AlarmsProvider>(context, listen: false)
                        .addAlarm(newAlarm);
                  }

                  Navigator.pop(context);
                }),
          ),
        ),
      );
    });
  }
}
