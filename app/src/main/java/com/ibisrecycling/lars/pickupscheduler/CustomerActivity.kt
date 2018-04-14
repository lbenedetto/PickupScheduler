package com.ibisrecycling.lars.pickupscheduler

import android.content.res.Resources
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.support.v7.app.AppCompatActivity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.DatePicker
import android.widget.EditText
import android.widget.RadioGroup
import com.ibisrecycling.lars.pickupscheduler.utils.Customer
import com.ibisrecycling.lars.pickupscheduler.utils.CustomerManager
import java.util.*

class CustomerActivity : AppCompatActivity() {
	lateinit var customerManager: CustomerManager
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_customer)
		customerManager = CustomerManager(this)

		findViewById<Button>(R.id.buttonImport).setOnClickListener({
			//TODO: Implement importing from PayWhirl
		})

		findViewById<Button>(R.id.buttonAdd).setOnClickListener({ view ->
			val dialogBuilder = AlertDialog.Builder(this)
			val dialogView = layoutInflater.inflate(R.layout.customer_creation_dialog, null)
			val dialog = dialogBuilder.setView(dialogView).create()
			val datePicker = dialogView.findViewById<DatePicker>(R.id.datePicker)

			dialogView.findViewById<Button>(R.id.buttonDone).setOnClickListener({
				customerManager.addCustomer(Customer(
						name = dialogView.findViewById<EditText>(R.id.editTextName).text.toString(),
						address = dialogView.findViewById<EditText>(R.id.editTextAddress).text.toString(),
						subscriptionType = dialogView.findViewById<RadioGroup>(R.id.radioGroup).getSelectedFrequency(),
						startDate = datePicker.getDate(),
						context = this
				))
				dialog.dismiss()
			})

			dialogView.findViewById<Button>(R.id.buttonCancel).setOnClickListener({ dialog.dismiss() })

			dialog.show()
		})
	}

	private fun DatePicker.getDate(): Date {
		val c = Calendar.getInstance()
		c.set(this.dayOfMonth, this.month, this.year)
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