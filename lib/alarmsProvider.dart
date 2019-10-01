import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Alarms.dart';
import 'dart:convert';

class AlarmsProvider with ChangeNotifier {
  List<YAlarms> alarms = List<YAlarms>();
  List jSonAlarms = [];
  SharedPreferences prefs;

  void addAlarm(YAlarms alarm, [int index]) {
    if (alarms == null) {
      alarms = [];
    }
    if (alarm.title == null || alarm.title == '') {
      alarm.title = 'No name';
    }
    if (alarm.daySelector == null) {
      alarm.daySelector = [0, 0, 0, 0, 0, 0, 0];
    }
    int lastID = alarms.length != 0 ? alarms[alarms.length - 1].id : 0;
    alarm.id = alarms.length != 0 ? lastID + 1 : 1;
    if (index != null) {
      alarms.insert(index, alarm);
    } else {
      alarms.add(alarm);
    }
    notifyListeners();
    updateLocalStorage();
  }

  void updateAlarm(YAlarms oldAlarm, YAlarms newAlarm) {
    int i = 0;
    alarms.forEach((item) {
      if (item.id == oldAlarm.id) {
        alarms[i].id = newAlarm.id;
        alarms[i].title = newAlarm.title;
        alarms[i].daySelector = newAlarm.daySelector;
        alarms[i].time = newAlarm.time;
        alarms[i].runOnlyOnce = newAlarm.runOnlyOnce;
      }
      i++;
    });
    notifyListeners();
    updateLocalStorage();
  }

  void updateAllAlarms(newAlarms) {
    alarms = newAlarms;
    notifyListeners();
    updateLocalStorage();
  }

  void removeAlarm(int alarmID) {
    YAlarms alarmToRemove;
    alarms.forEach((item) {
      if (item.id == alarmID) {
        alarmToRemove = item;
      }
    });
    alarms.remove(alarmToRemove);

    updateLocalStorage();
    notifyListeners();
  }

  void updateLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
    String tempSave = '';
    List jSonAlarms = [];
    alarms.forEach((item) {
      var customJson = {
        'id': item.id,
        'title': item.title,
        'daySelector': item.daySelector.toString(),
        'time': item.time.toString(),
        'runOnlyOnce': item.runOnlyOnce.toString(),
        'isEnabled': item.isEnabled.toString(),
      };
      jSonAlarms.add(customJson);
    });
    tempSave = jsonEncode(jSonAlarms);
    prefs.setString('allAlarms', tempSave);
    notifyListeners();
  }

  void getLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
    String tempGet = '';
    List jSonAlarms = [];
    tempGet = prefs.getString('allAlarms');
    if (tempGet != null) {
      jSonAlarms = jsonDecode(tempGet);
      jSonAlarms.forEach((item) {
        YAlarms tempAlarm = new YAlarms();
        tempAlarm.id = item['id'];
        tempAlarm.title = item['title'];
        tempAlarm.runOnlyOnce = item['runOnlyOnce'] == 'true';
        tempAlarm.isEnabled = item['isEnabled'] == 'true';
        List<dynamic> tempDaySelectorPrequel = jsonDecode(item['daySelector']);
        List<int> tempDaySelector = tempDaySelectorPrequel.map((item) {
          return item is int ? item : int.parse(item);
        }).toList();
        tempAlarm.daySelector = tempDaySelector;

        tempAlarm.time =
            item['time'] != 'null' ? DateTime.parse(item['time']) : null;
        alarms.add(tempAlarm);
      });
      notifyListeners();
    }
  }
}
