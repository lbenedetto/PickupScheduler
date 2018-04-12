package com.ibisrecycling.lars.pickupscheduler

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.CalendarView
import android.widget.TextView
import com.ibisrecycling.lars.pickupscheduler.utils.Customer
import com.ibisrecycling.lars.pickupscheduler.utils.CustomerManager
import java.util.*

class MainActivity : AppCompatActivity() {
	private lateinit var customerManager: CustomerManager
	private lateinit var MotD: TextView
	private lateinit var calendar: CalendarView

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_main)

		findViewById<Button>(R.id.buttonStart).setOnClickListener({ v ->
			val intent = Intent(v.context, PickupsActivity::class.java)
			startActivity(intent)
		})

		findViewById<Button>(R.id.buttonCustomers).setOnClickListener({ v ->
			val intent = Intent(v.context, PickupsActivity::class.java)
			startActivity(intent)
		})

		customerManager = CustomerManager(this)

		MotD = findViewById(R.id.textViewCustomerCount)
		updateMOTD(Date())

		calendar = findViewById(R.id.calendarView)
		calendar.maxDate = (Date().time) + (62 * Customer.daysToMillis)
		calendar.setOnDateChangeListener({ view, year, month, day ->
			updateMOTD(Date(year, month, day))
		})

	}

	fun updateMOTD(date: Date) {
		val size = customerManager.getCustomersOnDate(date).size
		MotD.text = getString(R.string.welcome_message, size, if (size != 1) "s" else "")
	}
}
