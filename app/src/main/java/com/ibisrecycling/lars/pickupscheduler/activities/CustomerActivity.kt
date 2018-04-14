package com.ibisrecycling.lars.pickupscheduler.activities

import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.support.v7.app.AppCompatActivity
import android.widget.*
import com.ibisrecycling.lars.pickupscheduler.CustomerListAdapter
import com.ibisrecycling.lars.pickupscheduler.R
import com.ibisrecycling.lars.pickupscheduler.utils.Customer
import com.ibisrecycling.lars.pickupscheduler.utils.CustomerManager
import java.util.*

class CustomerActivity : AppCompatActivity() {
	lateinit var customerManager: CustomerManager
	lateinit var listView: ListView
	lateinit var adapter: CustomerListAdapter
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_customer)
		customerManager = CustomerManager(this)
		listView = findViewById(R.id.listView)
		adapter = CustomerListAdapter(customerManager)
		listView.adapter = adapter

		findViewById<Button>(R.id.buttonImport).setOnClickListener({
			//TODO: Implement importing from PayWhirl
		})

		findViewById<Button>(R.id.buttonAdd).setOnClickListener({ view ->
			val dialogBuilder = AlertDialog.Builder(this)
			val dialogView = layoutInflater.inflate(R.layout.customer_creation_dialog, null)
			val dialog = dialogBuilder.setView(dialogView).create()
			val datePicker = dialogView.findViewById<DatePicker>(R.id.datePicker)

			dialogView.findViewById<Button>(R.id.buttonDone).setOnClickListener({
				adapter.addCustomer(Customer(
						name = dialogView.findViewById<EditText>(R.id.editTextName).text.toString(),
						address = dialogView.findViewById<EditText>(R.id.editTextAddress).text.toString(),
						subscriptionType = dialogView.findViewById<RadioGroup>(R.id.radioGroup).getSelectedFrequency(),
						startDate = datePicker.getDate(),
						context = this)
				)
				dialog.dismiss()
			})

			dialogView.findViewById<Button>(R.id.buttonCancel).setOnClickListener({ dialog.dismiss() })

			dialog.show()
		})


	}

	private fun DatePicker.getDate(): Date {
		val c = Calendar.getInstance()
		c.set(this.year, this.month, this.dayOfMonth)
		return c.time
	}

	private fun RadioGroup.getSelectedFrequency(): Int {
		return when (this.checkedRadioButtonId) {
			R.id.radioButtonWeekly -> Frequency.WEEK.value
			R.id.radioButtonFortnightly -> Frequency.FORTNIGHT.value
			else -> Frequency.MONTH.value
		}
	}

	enum class Frequency(val value: Int) {
		WEEK(7), FORTNIGHT(14), MONTH(28);
	}
}