import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:pickup_scheduler/utils/Customer.dart';

class TravellingTrashmanSolver {
  static Future<String> getOptimalRoute(Point start, List<Customer> group, Point end) {
    String distanceMatrix = "https://maps.googleapis.com/maps/api/distancematrix/json";
    String locations = "${start.x},${start.y}";
    for (Customer c in group) {
      locations += "|${c.x},${c.y}";
    }

    distanceMatrix += "?origins=" + locations;
    distanceMatrix += "?destinations=" + locations;

    return http.get(distanceMatrix).then((response) {
      List<Point> sortedGroup = new List<Point>();
      List<List<int>> matrix = new List<List<int>>();
      for (int from = 0; from < group.length; from++) {
        for (int to = 0; to < group.length; to++) {

        }
      }
      //This should work as long as there are less than 23 customers in the group
      String mapsURL = "https://www.google.com/maps/dir/";
      for (Customer c in group) {
        mapsURL += "${c.x},${c.y}/";
      }
      return mapsURL;
    });
  }
}
