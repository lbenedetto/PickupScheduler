package com.ibisrecycling.lars.pickupscheduler.utils

import android.content.Context
import android.location.Geocoder
import android.widget.Toast
import com.google.android.gms.maps.model.LatLng
import java.text.SimpleDateFormat
import java.util.*


class Customer(s: String, private val context: Context) {
	val name: String
	val address: String
	private val frequency: Long //Time between pickups, in milliseconds
	private val startDate: Date
	private var nextPickupDateNull: Date? = null

	companion object {
		private val dateFormat = SimpleDateFormat("yyyy-mm-dd", Locale.US)
		const val daysToMillis: Long = 86400000
	}

	init {
		val data = s.split(",")
		name = data[0]
		address = data[1]
		frequency = data[2].toLong() * daysToMillis
		startDate = dateFormat.parse(data[3])
	}

	val location: Point by lazy {
		val address = Geocoder(context).getFromLocationName(address, 2)
		if (address != null) {
			val loc = address[0]
			Point(loc.latitude, loc.longitude)
		} else {
			Toast.makeText(context, "Invalid Address $address", Toast.LENGTH_LONG).show()
			Point(0.0, 0.0)
		}
	}
	val x: Double by lazy {
		location.x
	}
	val y: Double by lazy {
		location.y
	}

	private fun getNextPickupDateInSequence(): Date {
		val currentDate = Date()
		var pickupDate = if (nextPickupDateNull != null) startDate else nextPickupDateNull as Date
		return if (pickupDate.toInt() < currentDate.toInt()) {
			do {
				pickupDate = Date(pickupDate.time + frequency)
			} while (pickupDate.toInt() < currentDate.toInt())
			nextPickupDateNull = pickupDate
			pickupDate
		} else {
			pickupDate = Date(pickupDate.time + frequency)
			nextPickupDateNull = pickupDate
			pickupDate
		}
	}

	//Extending the Date class with a new function
	private fun Date.toInt(): Int = (this.year * 10000) + (this.month * 100) + this.day

	private fun resetPickupDateSequence() {
		nextPickupDateNull = null
	}

	fun getNextNPickupDates(n: Int): ArrayList<Date> {
		val dates = ArrayList<Date>()
		repeat(n, { _ -> dates.add(getNextPickupDateInSequence()) })
		resetPickupDateSequence()
		return dates
	}

	fun getNextPickupDate(): Date {
		return getNextNPickupDates(1)[0]
	}
}