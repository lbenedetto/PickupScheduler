import 'package:pickup_scheduler/utils/Customer.dart';
import 'package:pickup_scheduler/utils/Date.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:collection';

class CustomerManager {
  List<Customer> customers = new List<Customer>();

  CustomerManager() {
    _parseCustomers();
  }

  void _parseCustomers() async {
    String file = await rootBundle.loadString("/assets/customers.txt");
    List<String> data = file.split("\n");
    for (String line in data) {
      customers.add(new Customer(line));
    }
  }

  List<Customer> getTodaysCustomers() {
    return getCustomersOnDate(new Date.fromNow(new DateTime.now()));
  }

  List<Customer> getCustomersOnDate(Date date) {
    List<Customer> newCustomers = new List<Customer>();
    for (Customer c in customers) {
      if (c.startDate == date) newCustomers.add(c);
    }
    return newCustomers;
  }

  List<DateTime> getAllPickupDates(Date min, Date max) {
    HashSet<Date> dates = new HashSet<Date>();
    customers.forEach((customer) => dates.addAll(customer.getAllPickupDates(min, max)));
    List<DateTime> convertedDates = new List<DateTime>();
    for (Date d in dates) {
      convertedDates.add(d.getAsDateTime());
    }
    return convertedDates;
  }
}
