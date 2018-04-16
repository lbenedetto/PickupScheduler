import 'package:flutter/material.dart';
import 'package:small_calendar/small_calendar.dart';
import 'utils/Date.dart';
import 'dart:async';
import 'utils/CustomerManager.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key, this.manager}) : super(key: key);
  final CustomerManager manager;

  @override
  State createState() {
    final DateTime now = new DateTime.now();
    final Date initialDate = new Date(now.year, now.month, 1);
    return new _ScheduleScreenState(manager, initialDate.asDateTime());
  }
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  _ScheduleScreenState(this.manager, this.initialDate) : super();
  List<DateTime> pickups;
  final DateTime initialDate;
  final DateTime now = new DateTime.now();
  final CustomerManager manager;
  bool showWeekdayIndication = true;
  bool showTicks = true;
  String displayedMonthText = "____";
  Widget smallCalendar;
  SmallCalendarController smallCalendarController;
  @override
  void initState() {
    super.initState();
    Date d = new Date(initialDate.year, initialDate.month, 1);
    displayedMonthText = "${d.monthString()} ${initialDate.year}";
  }

  SmallCalendarController createSmallCalendarController() {
    int _containsN(DateTime day) {
    	if(pickups == null)
    		pickups = manager.getAllPickupDatesRaw(new Date(now.year, now.month, 1), new Date(now.year, now.month+1, 31));
      int count = 0;
      for (DateTime d in pickups) {
        if (d == day) count++;
      }
      return count;
    }

    Future<bool> hasTick1Callback(DateTime day) async => _containsN(day) >= 1;
    Future<bool> hasTick2Callback(DateTime day) async => _containsN(day) >= 2;
    Future<bool> hasTick3Callback(DateTime day) async => _containsN(day) >= 3;

    return new SmallCalendarController(
      isSelectedCallback: (DateTime day) async => false,
      hasTick1Callback: hasTick1Callback,
      hasTick2Callback: hasTick2Callback,
      hasTick3Callback: hasTick3Callback,
    );
  }

  Widget createSmallCalendar(BuildContext context) {
    smallCalendarController = createSmallCalendarController();
    return new SmallCalendar(
      firstWeekday: DateTime.sunday,
      controller: smallCalendarController,
      initialDate: initialDate,
      dayStyle: new DayStyleData(
        showTicks: showTicks,
        tick1Color: Colors.green,
        tick2Color: Colors.yellow[700],
        tick3Color: Colors.red[700],
	      todayColor: Colors.deepPurple,
      ),
      showWeekdayIndication: showWeekdayIndication,
      weekdayIndicationStyle: new WeekdayIndicationStyleData(backgroundColor: Colors.red[700]),
      weekdayIndicationHeight: 60.0,
      onDayPressed: (DateTime date) {
	      Scaffold.of(context).showSnackBar(new SnackBar(
		      content: new Text(_getDayString(date)),
	      ));
      },
      onDisplayedMonthChanged: (int year, int month) {
        setState(() {
          Date d = new Date(year, month, 1);
          displayedMonthText = "${d.monthString()} $year";
        });
      },
    );
  }

	String _getDayString(DateTime date){
  	Date d = new Date.fromDateTime(date);
  	int size = manager.getCustomersOnDate(d).length;
  	return "We have $size customer${size == 1 ? "" : "s"} on ${d.asString()}";
	}

  @override
  Widget build(BuildContext context) {
    if (smallCalendar == null) {
      smallCalendar = createSmallCalendar(context);
    }

    return new Scaffold(
        body:
            // Creates an inner BuildContext so that the onDayPressed method in SmallCalendar
            // can refer to the Scaffold with Scaffold.of().
            new Builder(
          builder: (BuildContext context) {
            return new Column(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: new Text(
                    displayedMonthText,
                    style: new TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // calendar
                new Expanded(
                  child: new Container(
                    padding: const EdgeInsets.all(16.0),
                    child: new Center(
                      child: new Container(
                        color: Theme.of(context).cardColor,
                        // Small Calendar ------------------------------------------
                        child: smallCalendar,
                        // ---------------------------------------------------------
                      ),
                    ),
                  ),
                ),
                // controls
              ],
            );
          },
        ),
      );
  }
}
