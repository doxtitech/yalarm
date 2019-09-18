import 'package:day_selector/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Alarms.dart';
import 'dart:convert';

class AlarmsProvider with ChangeNotifier {
  List<YAlarms> alarms = List<YAlarms>();
  List jSonAlarms = [];
  SharedPreferences prefs;

  void addAlarm(YAlarms alarm) {
    if (alarms == null) {
      alarms = [];
    }
    if (alarm.title == '') {
      alarm.title = 'No name';
    }
    if (alarm.daySelector == null) {
      alarm.daySelector = new DaySelector();
    }
    alarms.add(alarm);
    notifyListeners();
    updateLocalStorage();
  }

  void updateAlarm(YAlarms oldAlarm, YAlarms newAlarm) {
    int i = 0;
    alarms.forEach((item) {
      if (item.title == oldAlarm.title) {
        alarms[i].title = newAlarm.title;
        alarms[i].daySelector = newAlarm.daySelector;
        alarms[i].runOnlyOnce = newAlarm.runOnlyOnce;
      }
      i++;
    });
    notifyListeners();
    updateLocalStorage();
  }

  void removeAlarm(String alarmName) {
    YAlarms alarmToRemove;
    alarms.forEach((item) {
      if (item.title == alarmName) {
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
        'title': item.title,
        'daySelecter': item.daySelector.toString(),
        'time': item.time.toString(),
        'runOnlyOnce': item.runOnlyOnce.toString(),
      };
      jSonAlarms.add(customJson);
    });
    tempSave = jsonEncode(jSonAlarms);
    print(jsonEncode(tempSave));
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
        tempAlarm.title = item['title'];
        tempAlarm.runOnlyOnce = item['runOnlyOnce'] == 'true' ? true : false;
        tempAlarm.time =
            item['time'] != 'null' ? DateTime.parse(item['time']) : null;
        alarms.add(tempAlarm);
      });
      notifyListeners();
    }
  }
}
