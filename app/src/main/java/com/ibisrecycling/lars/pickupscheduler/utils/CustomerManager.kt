package com.ibisrecycling.lars.pickupscheduler.utils

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import com.ibisrecycling.lars.pickupscheduler.utils.DateConversions.Companion.getAsInt
import java.util.*

class CustomerManager(private val context: Context) {
	private val key: String = "customers"
	private val sharedPrefs: SharedPreferences = context.getSharedPreferences(key, MODE_PRIVATE)
	private val allCustomers: ArrayList<Customer>? = null
	private var updated: Boolean = false

	fun getAllCustomers(): ArrayList<Customer> {
		if (updated || allCustomers == null) {
			val customers = sharedPrefs.getStringSet(key, HashSet<String>())
			val customerList = ArrayList<Customer>()
			customers.forEach({ customer ->
				customerList.add(Customer(customer, context))
			})
			return customerList
		}
		updated = false
		return allCustomers
	}

	fun ArrayList<Customer>.allToString(): HashSet<String> {
		val set = HashSet<String>()
		this.forEach({ customer ->
			set.add(customer.toString())
		})
		return set
	}

	fun saveCustomers(customers: ArrayList<Customer>) {
		saveCustomers(customers.allToString())
	}

	fun saveCustomers(customers: HashSet<String>) {
		sharedPrefs.edit()
				.putStringSet(key, customers)
				.apply()
		updated = true
	}

	private fun removeAllCustomers() {
		sharedPrefs.edit()
				.putStringSet(key, null)
				.apply()
		updated = true
	}

	fun addCustomer(customer: Customer) {
		addCustomer(customer.toString())
	}

	fun addCustomer(customer: String) {
		val customers = sharedPrefs.getStringSet(key, HashSet<String>())
		customers.add(customer)
		saveCustomers(customers as HashSet<String>)
		updated = true
	}

	val todaysCustomers: ArrayList<Customer>
		get() {
			return getCustomersOnDate(Date())
		}

	fun getCustomersOnDate(date: Date): ArrayList<Customer> {
		val customers = ArrayList<Customer>()
		getAllCustomers().forEach({ customer ->
			if (customer.getNextNPickupDates(12).contains(date)) customers.add(customer)
		})
		return customers
	}

	fun getAllPickupDates(min: Date, max: Date): HashSet<Date> {
		val dates = HashSet<Date>()
		getAllCustomers().forEach({ customer ->
			customer.getNextNPickupDates(12).forEach({ date ->
				if (getAsInt(date) >= getAsInt(min) && getAsInt(date) <= getAsInt(max)) dates.add(date)
			})
		})
		return dates
	}
}