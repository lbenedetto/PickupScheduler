package com.ibisrecycling.lars.pickupscheduler.utils

import java.text.SimpleDateFormat
import java.util.*


class Customer(s: String) {
	val name: String
	val address: String
	val frequency: Long //Time between pickups, in milliseconds
	val startDate: Date
	private var nextPickupDateNull: Date? = null

	companion object {
		private val dateFormat = SimpleDateFormat("yyyy-mm-dd", Locale.US)
		val daysToMillis: Long = 86400000
	}

	init {
		val data = s.split(",")
		name = data[0]
		address = data[1]
		frequency = data[2].toLong() * daysToMillis
		startDate = dateFormat.parse(data[3])
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
	fun Date.toInt(): Int = (this.year * 10000) + (this.month * 100) + this.day

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