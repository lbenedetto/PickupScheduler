import 'package:flutter/material.dart';
import 'package:pickup_scheduler/CustomerScreen.dart';
import 'package:pickup_scheduler/PickupsScreen.dart';
import 'package:pickup_scheduler/ScheduleScreen.dart';
import 'package:pickup_scheduler/utils/CustomerManager.dart';

void main() {
	CustomerManager manager = new CustomerManager();
	manager.parseCustomers().then((result) {
		runApp(new MyApp(manager: manager));
	});
}

class MyApp extends StatelessWidget {
  MyApp({Key key, this.manager}) : super(key: key);
  final CustomerManager manager;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.red,
        brightness: Brightness.dark,
      ),
      home: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Ibis Recycling Driver App"),
            bottom: new TabBar(
              tabs: <Widget>[
                new Tab(icon: new Icon(Icons.calendar_today), text: "Schedule"),
                new Tab(icon: new Icon(Icons.account_circle), text: "Customers"),
                new Tab(icon: new Icon(Icons.near_me), text: "Route Planner"),
              ],
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              new ScheduleScreen(manager: manager),
              new CustomerScreen(customers: manager.customers),
              new PickupsScreen(manager: manager)
            ],
          ),
        ),
      ),
    );
  }
}
