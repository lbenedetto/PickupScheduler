import 'package:pickup_scheduler/utils/Customer.dart';
import 'dart:math';

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

  bool _isOutOfBoundsX(double x) {
    return x > maxX || x < minX;
  }

  bool _isOutOfBoundsY(double y) {
    return y > maxY || y < minY;
  }

  Point getRandomPointInBounds() {
    double x;
    double y;
    var rng = new Random();
    do {
      x = rng.nextDouble();
    } while (_isOutOfBoundsX(x));
    do {
      x = rng.nextDouble();
    } while (_isOutOfBoundsY(y));
    return new Point(x, y);
  }
}
