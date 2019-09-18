import 'package:flutter/material.dart';

class YADayPicker extends StatefulWidget {
  // [0,0,1,0,0,0,1] - 1 for selected day, 0 for unselected
  List<int> selectedDays = [];
  YADayPicker({Key key, this.selectedDays}) : super(key: key);
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
    int i = 0;
    _selectedDays.forEach((item) {
      _daysOfWeekWidgets.add(Column(
        children: <Widget>[
          Text(_dayOfWeek[i]),
          Checkbox(
            value: _selectedDays[i] == 0 ? false : true,
            onChanged: (bool value) {
              setState(() {
                _selectedDays[i] = value == true ? 0 : 1;
              });
            },
          )
        ],
      ));
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        children: _daysOfWeekWidgets,
      ),
    );
  }
}
