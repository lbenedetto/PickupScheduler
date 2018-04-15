package com.ibisrecycling.lars.pickupscheduler.activities

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import com.ibisrecycling.lars.pickupscheduler.R
import com.ibisrecycling.lars.pickupscheduler.utils.Customer
import com.ibisrecycling.lars.pickupscheduler.utils.CustomerManager
import com.squareup.timessquare.CalendarPickerView
import java.util.*

class MainActivity : AppCompatActivity() {
	private lateinit var customerManager: CustomerManager
	private lateinit var MOTD: TextView
	private lateinit var calendar: CalendarPickerView

	companion object {
		val maxDate = Date((Date().time) + (62 * Customer.daysToMillis))
	}

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_main)

		findViewById<Button>(R.id.buttonStart).setOnClickListener({ v ->
			startActivity(Intent(v.context, PickupsActivity::class.java))
		})

		findViewById<Button>(R.id.buttonCustomers).setOnClickListener({ v ->
			startActivity(Intent(v.context, CustomerActivity::class.java))
		})

		customerManager = CustomerManager(this)

		MOTD = findViewById(R.id.textViewCustomerCount)
		updateMOTD(Date())

		calendar = findViewById(R.id.calendarView)
		calendar.init(Date(), maxDate).withSelectedDate(Date())
		calendar.setOnDateSelectedListener(object : CalendarPickerView.OnDateSelectedListener {
			override fun onDateSelected(date: Date) {
				updateMOTD(date)
			}

			override fun onDateUnselected(date: Date?) {}
		})
		highlightDates()
	}

	private fun updateMOTD(date: Date) {
		val size = customerManager.getCustomersOnDate(date).size
		MOTD.text = getString(R.string.welcome_message, size, if (size != 1) "s" else "")
	}

	private fun highlightDates() {
		calendar.highlightDates(customerManager.getAllPickupDates(Date(), maxDate))
	}

	override fun onRestart() {
		super.onRestart()
		highlightDates()
	}
}
