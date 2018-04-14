package com.ibisrecycling.lars.pickupscheduler

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Button
import android.widget.TextView
import com.ibisrecycling.lars.pickupscheduler.utils.Customer
import com.ibisrecycling.lars.pickupscheduler.utils.DateConversions.Companion.getAsString
import java.util.*


class CustomerListAdapter(val a: ArrayList<Customer>) : BaseAdapter() {
	override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
		val view =
				if (convertView != null) {
					convertView
				} else {
					val inflater = parent!!.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
					inflater.inflate(R.layout.customer_item, parent, false)
				}
		val customer = a[position]
		view.findViewById<TextView>(R.id.textViewName).text = customer.name
		view.findViewById<TextView>(R.id.textViewAddress).text = customer.address
		view.findViewById<TextView>(R.id.textViewFrequency).text = getTypeName(customer.subscriptionType)
		view.findViewById<TextView>(R.id.textViewNextDate).text = getAsString(customer.getNextPickupDate())
		view.findViewById<Button>(R.id.buttonEdit).setOnClickListener({
			//TODO: Edit dialog
		})
		view.findViewById<Button>(R.id.buttonDelete).setOnClickListener {
			a.removeAt(position)
			notifyDataSetChanged()
		}

		return view
	}

	private fun getTypeName(i: Int): String {
		return when (i) {
			7 -> "Weekly"
			14 -> "Fortnightly"
			else -> "Monthly"
		}
	}

	override fun getItem(position: Int): Any {
		return a[position]
	}

	override fun getItemId(position: Int): Long {
		return position.toLong()
	}

	override fun getCount(): Int {
		return a.size
	}

}