import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmsProvider with ChangeNotifier {
  List<String> alarms = List<String>();
  SharedPreferences prefs;

  void addAlarm(String alarmName) {
    alarms.add(alarmName);
    notifyListeners();
    updateLocalStorage();
  }

  void updateAlarm(String oldAlarmName, String newAlarmName) {
    int i = 0;
    alarms.forEach((item) {
      if (item == oldAlarmName) {
        alarms[i] = newAlarmName;
        return false;
      }
      i++;
    });
    notifyListeners();
    updateLocalStorage();
  }

  void removeAlarm(String alarmName) {
    alarms.remove(alarmName);
    notifyListeners();
    updateLocalStorage();
  }

  void updateLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList('allAlarms', alarms);
    notifyListeners();
  }

  void getLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
    alarms = prefs.getStringList('allAlarms');
    notifyListeners();
  }
}
