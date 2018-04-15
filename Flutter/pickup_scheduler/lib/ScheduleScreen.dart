import 'package:flutter/material.dart';

//https://github.com/ZedTheLed/small_calendar
class ScheduleScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context){
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Schedule'),
			),
			body: new Center(
				child: new RaisedButton(
					child: new Text('View Customers'),
					onPressed: () => Navigator.of(context).pushNamed('/customers'),
				),
			),
		);
	}
}
