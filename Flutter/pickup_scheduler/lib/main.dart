import 'package:flutter/material.dart';
import 'package:pickup_scheduler/CustomerScreen.dart';
import 'package:pickup_scheduler/PickupsScreen.dart';
import 'package:pickup_scheduler/ScheduleScreen.dart';
import 'package:pickup_scheduler/utils/CustomerManager.dart';

void main() {
	runApp(new MyApp(manager: new CustomerManager()));
}

class MyApp extends StatelessWidget {
	MyApp({Key key, this.manager}) : super(key: key);

	final CustomerManager manager;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pickup Scheduler',
      theme: new ThemeData(
        primaryColor: Colors.red,
        brightness: Brightness.dark,
      ),
      home: new ScheduleScreen(),
	    routes: <String, WidgetBuilder>{
      	'/customers': (BuildContext context) => new CustomerScreen(customers: manager.customers),
		    '/pickups' : (BuildContext context) => new PickupsScreen(),
		    '/schedule' : (BuildContext context) => new ScheduleScreen(),
	    },
    );
  }
}