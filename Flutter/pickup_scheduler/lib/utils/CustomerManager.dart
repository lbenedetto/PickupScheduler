import 'package:pickup_scheduler/utils/Customer.dart';
import 'package:pickup_scheduler/utils/Date.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:collection';

class CustomerManager {
  List<Customer> customers = new List<Customer>();

  CustomerManager() {
    _parseCustomers();
//    customers.add(new Customer("Carol::705 Golden Hills Drive, Cheney WA, 99004::7::2018::4::18"));
//    customers.add(new Customer("Chris::1012 Moyer St::14::2018::4::17"));
  }

  void _parseCustomers() async {
    String file = await rootBundle.loadString("assets/customers.txt");
    List<String> data = file.split("\n");
    for (String line in data) {
      customers.add(new Customer(line));
    }
  }

  List<Customer> getTodaysCustomers() {
    return getCustomersOnDate(new Date.fromDateTime(new DateTime.now()));
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
