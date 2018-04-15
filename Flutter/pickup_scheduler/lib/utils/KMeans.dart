import 'package:pickup_scheduler/utils/Customer.dart';
import 'package:pickup_scheduler/utils/BoundingBox.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class KMeans {
  static const int GROUP_SIZE = 4; //TODO: Make this configurable
  static const int MAX_ITERATIONS = 100;
  List<Customer> customers;

  KMeans(List<Customer> customers) {
    this.customers = customers;
  }

  ///
  /// Implements K-Means algorithm to find clusters of customers of size GROUP_SIZE
  /// http://stanford.edu/~cpiech/cs221/handouts/kmeans.html
  /// https://mubaris.com/2017/10/01/kmeans-clustering-in-python/
  ///
  /// @returns A list of groups of customers
  ///
  List<List<Customer>> generateGroups() {
    int iterations = 0;
    int k = (customers.length / GROUP_SIZE).ceil(); //Target number of groups
    BoundingBox box = new BoundingBox(customers); //The bounding box surrounding all the customers
    List<Point> oldCentroids = new List<Point>(k); //List of previous centroids to check if we're making progress
    List<List<Customer>> clusters = new List<List<Customer>>(); //List of generated clusters so far
    Function deepEq = const DeepCollectionEquality().equals;

    //Initialize the centroids to random points
    List<Point> centroids = new List<Point>(k);
    for (int i = 0; i < k; i++) centroids.add(box.getRandomPointInBounds());

    //Begin the algorithm
    while ((iterations < MAX_ITERATIONS) && !(deepEq(oldCentroids, centroids))) {
      oldCentroids = centroids;
      iterations++;

      //Each customer joins a cluster based on their nearest centroid
      for (int i = 0; i < customers.length; i++) {
        clusters[getIndexOfNearestCentroid(customers[i], centroids)].add(customers[i]);
      }

      //Move the centroids to the geometric mean of their cluster
      //If nobody joined the cluster, put it somewhere random
      for (int i = 0; i < centroids.length; i++) {
        if (clusters[i].isEmpty)
          centroids[i] = box.getRandomPointInBounds();
        else
          centroids[i] = _geometricMean(clusters[i]);
      }
    }

    return clusters;
  }

  Point _geometricMean(List<Customer> customers) {
    double productX = 1.0;
    double productY = 1.0;
    double n = 1 / customers.length;
    for (Customer c in customers) {
      productX *= c.x;
      productY *= c.y;
    }
    return new Point(pow(productX, n), pow(productY, n));
  }

  int getIndexOfNearestCentroid(Customer customer, List<Point> centroids) {
    double min = 999999.0;
    int ix = 0;
    double dist;

    for (int i = 0; i < centroids.length; i++) {
      dist = centroids[i].squaredDistanceTo(customer.point);
      if (dist < min) {
        min = dist;
        ix = i;
      }
    }

    return ix;
  }
}
