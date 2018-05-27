import 'dart:math';

import 'package:pickup_scheduler/utils/Customer.dart';

class BoundingBox {
  double minX;
  double maxX;
  double minY;
  double maxY;

  BoundingBox(List<Customer> customers) {
    minX = customers[0].x;
    maxX = customers[0].x;
    minY = customers[0].y;
    maxY = customers[0].y;

    for (Customer c in customers) {
      minX = (c.x < minX) ? c.x : minX;
      maxX = (c.x > maxX) ? c.x : maxX;
      minY = (c.y < minX) ? c.y : minY;
      maxY = (c.y > maxY) ? c.y : maxY;
    }
  }

  Point getRandomPointInBounds() {
    var rng = new Random();
    //Interpolate randomly between min and max
    double x = ((rng.nextDouble() * (maxX - minX)) + minX);
    double y = ((rng.nextDouble() * (maxY - minY)) + minY);
    return new Point(x, y);
  }
}
