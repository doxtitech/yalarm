import 'package:flutter/material.dart';

class YADayPicker extends StatefulWidget {
  // [0,0,1,0,0,0,1] - 1 for selected day, 0 for unselected
  List<int> selectedDays = [];
  var getDayPickerDays;
  YADayPicker({Key key, this.selectedDays, this.getDayPickerDays})
      : super(key: key);
  YADayPickerState createState() => YADayPickerState();
}

class YADayPickerState extends State<YADayPicker> {
  List<int> _selectedDays = [];
  List<Widget> _daysOfWeekWidgets = [];
  List<String> _dayOfWeek = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDays =
        widget.selectedDays != null && widget.selectedDays.length > 0
            ? widget.selectedDays
            : [0, 0, 0, 0, 0, 0, 0];
  }

  List<int> getDayPickerDays(widgetDays) {
    return widget.getDayPickerDays(widgetDays);
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    _daysOfWeekWidgets = [];
    _selectedDays.forEach((item) {
      int z = i;
      _daysOfWeekWidgets.add(Column(
        children: <Widget>[
          Text(_dayOfWeek[i]),
          Checkbox(
            value: _selectedDays[i] != 0,
            onChanged: (bool value) {
              List<int> tempSelectedDays = [];
              for (int y = 0; y < _selectedDays.length; y++) {
                if (y == z) {
                  tempSelectedDays.add(value == true ? 1 : 0);
                } else {
                  tempSelectedDays.add(_selectedDays[y]);
                }
              }
              setState(() {
                _selectedDays = tempSelectedDays;
              });
              getDayPickerDays(_selectedDays);
            },
          )
        ],
      ));
      i++;
    });
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        children: _daysOfWeekWidgets,
      ),
    );
  }
}
