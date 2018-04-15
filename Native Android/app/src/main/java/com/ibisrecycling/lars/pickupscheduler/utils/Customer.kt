package com.ibisrecycling.lars.pickupscheduler.utils

import android.content.Context
import android.location.Geocoder
import android.widget.Toast
import com.ibisrecycling.lars.pickupscheduler.utils.DateConversions.Companion.getAsInt
import com.ibisrecycling.lars.pickupscheduler.utils.DateConversions.Companion.getAsString
import java.text.SimpleDateFormat
import java.util.*


class Customer(
		val name: String,
		val address: String,
		val subscriptionType: Int,
		val startDate: Date,
		private val context: Context) {

	private val frequency: Long

	override fun toString(): String {
		return "$name::$address::${frequency / daysToMillis}::${getAsString(startDate)}"
	}

	init {
		frequency = subscriptionType * daysToMillis
	}

	companion object {
		private val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
		const val daysToMillis: Long = 86400000
	}

	constructor(s: List<String>, context: Context) : this(
			s[0],
			s[1],//TODO: Addresses contain commas, deal with it
			s[2].toInt(),
			dateFormat.parse(s[3]),
			context)

	constructor(s: String, context: Context) : this(
			s.split("::"),
			context)

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

	fun getNextNPickupDates(n: Int): ArrayList<Date> {
		val dates = ArrayList<Date>()
		val currentDate = Date()
		var pickupDate = startDate

		//Fast-forward the start date to the present date
		while (getAsInt(pickupDate) < getAsInt(currentDate))
			pickupDate = Date(pickupDate.time + frequency)
		dates.add(pickupDate)

		//We can now work forward n - 1 times
		repeat(n - 1, {
			pickupDate = Date(pickupDate.time + frequency)
			dates.add(pickupDate)
		})

		return dates
	}

	fun getNextPickupDate(): Date {
		return getNextNPickupDates(1)[0]
	}
}