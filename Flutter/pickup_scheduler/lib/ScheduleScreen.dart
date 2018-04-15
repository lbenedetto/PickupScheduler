import 'package:flutter/material.dart';
import 'package:small_calendar/small_calendar.dart';
import 'utils/Customer.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({Key key, this.customers}) : super(key: key);
  final List<Customer> customers;

  @override
  Widget build(BuildContext context) {
    final DateTime now = new DateTime.now();
    final smallCalendar = new SmallCalendar(
      initialDate: new DateTime(now.year, now.month, 1),
      firstWeekday: DateTime.sunday,
    );

    return new Scaffold(
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            smallCalendar,
            new Text("We have 0 customers today"), //TODO: Dynamic update for selected date
          ],
        ),
      ),
    );
  }
}
