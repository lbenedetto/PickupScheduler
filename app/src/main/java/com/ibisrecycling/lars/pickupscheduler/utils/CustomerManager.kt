package com.ibisrecycling.lars.pickupscheduler.utils

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import com.ibisrecycling.lars.pickupscheduler.utils.DateConversions.Companion.getAsInt
import java.util.*

class CustomerManager(private val context: Context) {
	private val sharedPrefs: SharedPreferences = context.getSharedPreferences(key, MODE_PRIVATE)

	companion object {
		private const val key: String = "customers"
		private var updated: Boolean = false
		private var allCustomers: ArrayList<Customer>? = null
	}

	fun getAllCustomers(): ArrayList<Customer> {
		if (updated || allCustomers == null) {
			val customers = sharedPrefs.getStringSet(key, HashSet<String>())
			val customerList = ArrayList<Customer>()
			customers.forEach({ customer ->
				customerList.add(Customer(customer, context))
			})
			updated = false
			allCustomers = customerList
			return customerList
		}
		return allCustomers as ArrayList<Customer>
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

	private fun saveCustomers(customers: HashSet<String>) {
		val editor = sharedPrefs.edit()
		editor.clear()
		editor.putStringSet(key, customers)
		editor.apply()
		updated = true
	}

//	private fun removeAllCustomers() {
//		val editor = sharedPrefs.edit()
//		editor.putStringSet(key, null)
//		editor.apply()
//		updated = true
//	}

	fun addCustomer(customer: Customer) {
		val customers = sharedPrefs.getStringSet(key, HashSet<String>())
		customers.add(customer.toString())
		saveCustomers(customers as HashSet<String>)
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