import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class alarmsProvider with ChangeNotifier {
  List<String> alarms = List<String>();

  void addAlarm(String alarmName) {
    alarms.add(alarmName);
    notifyListeners();
  }

  void editAlarm(String oldAlarmName,String newAlarmName){
    int i = 0;
    alarms.forEach((item){
      if(item == oldAlarmName){
        alarms[i] = newAlarmName;
        return false;
      }
      i++;
    });
    notifyListeners();
  }
  void removeAlarm(String alarmName){
    alarms.remove(alarmName);
    notifyListeners();
  }
}
