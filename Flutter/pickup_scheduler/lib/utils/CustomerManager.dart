import 'package:pickup_scheduler/utils/Customer.dart';
import 'package:pickup_scheduler/utils/Date.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:collection';
import 'dart:async';

class CustomerManager {
  List<Customer> customers = new List<Customer>();

  CustomerManager() {
//    customers.add(new Customer("Carol::705 Golden Hills Drive, Cheney WA, 99004::7::2018::4::18"));
//    customers.add(new Customer("Chris::1012 Moyer St::7::2018::4::17"));
  }

  Future<List<Customer>> parseCustomers() async {
    String file = await rootBundle.loadString("assets/customers.txt");
    List<String> data = file.split("\n");
    for (String line in data) {
      customers.add(new Customer(line));
    }
    return customers;
  }

  List<Customer> getNextPickupsCustomers() {
    Date date = new Date.fromDateTime(new DateTime.now());
    List<Customer> customers = getCustomersOnDate(date);
    while(customers.length == 0){
      date = new Date.fromDateTime(date.add(new Duration(days: 1)));
      customers = getCustomersOnDate(date);
    }

    return customers;
  }

  List<Customer> getCustomersOnDate(Date date) {
    List<Customer> newCustomers = new List<Customer>();
    for (Customer c in customers) {
      if (c.getAllPickupDates(date, date).contains(date)) newCustomers.add(c);
    }
    return newCustomers;
  }

  List<DateTime> getAllPickupDates(Date min, Date max) {
    HashSet<Date> dates = new HashSet<Date>();
    for (Customer c in customers) {
      dates.addAll(c.getAllPickupDates(min, max));
    }
    List<DateTime> convertedDates = new List<DateTime>();
    for (Date d in dates) {
      convertedDates.add(d.asDateTime());
    }
    return convertedDates;
  }

  List<DateTime> getAllPickupDatesRaw(Date min, Date max){
    List<Date> dates = new List<Date>();
    for (Customer c in customers) {
      dates.addAll(c.getAllPickupDates(min, max));
    }
    List<DateTime> convertedDates = new List<DateTime>();
    for (Date d in dates) {
      convertedDates.add(d.asDateTime());
    }
    return convertedDates;
  }
}
