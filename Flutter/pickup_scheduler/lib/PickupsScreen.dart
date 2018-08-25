import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils/Customer.dart';
import 'utils/CustomerManager.dart';
import 'utils/KMeans.dart';
import 'utils/TravellingTrashmanSolver.dart';

class PickupsScreen extends StatelessWidget {
  PickupsScreen({Key key, this.manager}) : super(key: key);
  final CustomerManager manager;

  @override
  Widget build(BuildContext context) {
    KMeans kmeans = new KMeans(manager.getNextPickupsCustomers());
    List<List<Customer>> groups = kmeans.generateGroups();

    return new Scaffold(
      body: _buildList(groups),
    );
  }

  Widget _buildList(List<List<Customer>> groups) {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groups.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          return _buildRow(groups[index], index);
        });
  }

  Widget _buildRow(List<Customer> group, int ix) {
    String addressList = "";
    for (Customer c in group) {
      addressList += "${c.address}\n";
    }
    String groupName = "Group ${ix + 1}";
    return new Container(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    groupName,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  addressList,
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Row(
            children: <Widget>[
              new CheckBox(),
              new LabeledIcon(
                icon: Icons.near_me,
                label: "Route",
                group: group,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CheckBox extends StatefulWidget {
  @override
  _CheckBoxState createState() => new _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isChecked = false;

  void _toggleChecked() {
    setState(() {
      if (_isChecked) {
        _isChecked = false;
      } else {
        _isChecked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconButton(
          icon: (_isChecked ? new Icon(Icons.check_box) : new Icon(Icons.check_box_outline_blank)),
          color: Colors.red[500],
          onPressed: _toggleChecked,
        ),
        new Container(
          child: new Text(
            "Done",
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledIcon extends StatelessWidget {
  LabeledIcon({Key key, this.icon, this.label, this.group}) : super(key: key);
  final IconData icon;
  final String label;
  final List<Customer> group;

  void _navigate() async {
    Map<String, double> location = await new Location().getLocation;
    Point start = new Point(location["latitude"], location["longitude"]); //Current Location
    Point end = new Point(47.492921, -117.564710); //Cheney Recycling center
    String route = await TravellingTrashmanSolver.getOptimalRoute(start, group, end);
    launch(route, forceSafariVC: false, forceWebView: false);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconButton(
          icon: new Icon(Icons.near_me),
          color: Colors.red[500],
          onPressed: _navigate,
        ),
        new Container(
          child: new Text(
            label,
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
