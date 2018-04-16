import 'package:flutter/material.dart';
import 'utils/Customer.dart';
import 'utils/Date.dart';

class CustomerScreen extends StatelessWidget {
	CustomerScreen({Key key, this.customers}) : super(key: key);
	final List<Customer> customers;
	@override
	Widget build(BuildContext context){
		return new Scaffold(
			body: _buildList(customers),
		);
	}

	Widget _buildList(List<Customer> customers){
		return new ListView.builder(
			padding: const EdgeInsets.all(16.0),
			itemCount: customers.length * 2,
			itemBuilder: (context, i){
		    if(i.isOdd) return new Divider();
		    final index = i ~/ 2;
		    return _buildRow(customers[index]);
		});
	}

	Widget _buildRow(Customer customer){
		final Date now = new Date.fromDateTime(new DateTime.now());
		final Date nextPickup = customer.getNextNPickupDates(1, now)[0];
		final isToday =  nextPickup == now;
		return new Container(
			padding: const EdgeInsets.all(16.0),
			child: new Row(
				children: [
					new Expanded(
						child: new Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								new Container(
									padding: const EdgeInsets.only(bottom: 8.0),
									child: new Text(
										customer.name,
										style: new TextStyle(
											fontWeight: FontWeight.bold,
										),
									),
								),
								new Text(
									customer.address,
									style: new TextStyle(
										color: Colors.grey[500],
									),
								),
								new Text(
									nextPickup.asString(),
									style: new TextStyle(
										color: Colors.grey[500],
									),
								),
							],
						),
					),
					new Icon(isToday ? Icons.label : Icons.label_outline),
				],
			),
		);
	}
}