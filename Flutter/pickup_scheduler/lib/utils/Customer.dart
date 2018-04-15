import 'package:geocoder/geocoder.dart';
import 'package:pickup_scheduler/utils/Date.dart';

class Customer {
  String name;
  String address;
  Duration offset;
  Date startDate;
  double x;
  double y;

  Customer(String c) {
    var data = c.split('::');
    this.name = data[0];
    this.address = data[1];
    this.offset = new Duration(days: int.parse(data[2]));
    this.startDate = new Date(int.parse(data[3]), int.parse(data[4]), int.parse(data[5]));
    calculateCoordinates();
  }

  calculateCoordinates() async {
    var loc = await Geocoder.local.findAddressesFromQuery(address);
    Coordinates coordinates = loc.first.coordinates;
    x = coordinates.latitude;
    y = coordinates.longitude;
  }

  List<Date> getNextNPickupDates(int n) {
    List<Date> dates = new List<DateTime>();
    Date currentDate = new Date.fromNow(new DateTime.now());
    Date pickupDate = startDate;

    //Fast-forward the start date to the present date
    while (pickupDate < currentDate) {
      pickupDate = pickupDate.add(offset);
    }
    dates.add(pickupDate);

    //We can now work forward n - 1 times
    for (int i = 1; i < n; i++) {
      pickupDate = pickupDate.add(offset);
      dates.add(pickupDate);
    }

    return dates;
  }

  List<Date> getAllPickupDates(Date min, Date max) {
		List<Date> dates = getNextNPickupDates(8);
		List<Date> filteredDates = new List<Date>();

		for(Date d in dates){
			if(d >= min && d <= max) filteredDates.add(d);
		}

		return filteredDates;
  }
}
