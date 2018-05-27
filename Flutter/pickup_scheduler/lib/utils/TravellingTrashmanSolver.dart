import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:pickup_scheduler/utils/Customer.dart';

class TravellingTrashmanSolver {
  static String getMatrixUrl(Point start, List<Customer> group, Point end) {
    String distanceMatrix = "https://maps.googleapis.com/maps/api/distancematrix/json";
    String locations = "${start.x},${start.y}";
    for (Customer c in group) {
      locations += "|${c.x},${c.y}";
    }
    locations += "|${end.x},${end.y}";
    distanceMatrix += "?origins=" + locations;
    distanceMatrix += "&destinations=" + locations;
    distanceMatrix += "&key=AIzaSyBNV_OcRZ6Esm8-w58FAOi5y9w57XFodxY";
    return distanceMatrix;
  }

  static Future<String> getOptimalRoute(final Point start, List<Customer> group, final Point end) async {
    List<Point> points = new List<Point>();
    points.add(start);
    for (Customer c in group) {
      points.add(new Point(c.x, c.y));
    }
    points.add(end);

    final response = await http.get(getMatrixUrl(start, group, end));
    final responseJson = json.decode(response.body);

    List<List<Node>> matrix = new List<List<Node>>();

    for (int from = 0; from < points.length; from++) {
      matrix.add(new List<Node>());
      for (int to = 0; to < points.length; to++) {
        matrix[from].add(new Node(points[to].x, points[to].y, responseJson["rows"][from]["elements"][to]["duration"]["value"]));
      }
    }
    Path startPath = new Path();
    startPath.add(matrix[0][0], 0);
    Path optimalPath = getOptimalPath(matrix, 0, startPath);

    //This should work as long as there are less than 23 customers in the group
    String mapsURL = "https://www.google.com/maps/dir/";
    for (Node n in optimalPath.path) {
      mapsURL += "${n.x},${n.y}/";
    }
    return mapsURL;
  }

  static Path getOptimalPath(List<List<Node>> matrix, int from, Path p) {
    if(from == matrix[0].length - 1) return p;
    List<Path> paths = new List<Path>();
    List<Node> nodes = matrix[from];
    for (int to = 1; to < nodes.length; to++) {
      if (p.visitedNodes.contains(to)) continue; //Already visited this node
      if (to == nodes.length - 1 && p.length != nodes.length - 1) continue; //Not yet ready to visit end node
      Path path = p.duplicate();
      path.add(matrix[from][to], to);
      paths.add(getOptimalPath(matrix, to, path));
    }
    Path shortest = paths[0];
    for (Path p in paths) {
      if (p.time < shortest.time) {
        shortest = p;
      }
    }
    return shortest;
  }
}

class Node {
  double x;
  double y;
  int time;

  Node(this.x, this.y, this.time);
}

class Path {
  List<int> visitedNodes;
  List<Node> path;
  int time;
  int length;

  Path() {
    path = new List<Node>();
    visitedNodes = new List<int>();
    time = 0;
    length = 0;
  }

  add(Node n, int ix) {
    path.add(n);
    time += n.time;
    length++;
    visitedNodes.add(ix);
  }

  Path duplicate() {
    Path newPath = new Path();
    for (Node n in path) {
      newPath.add(n, 0);
    }
    newPath.visitedNodes = new List<int>();
    for (int i in visitedNodes) {
      newPath.visitedNodes.add(i);
    }
    newPath.time = time;
    return newPath;
  }
}
