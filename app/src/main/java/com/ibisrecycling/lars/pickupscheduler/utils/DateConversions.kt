package com.ibisrecycling.lars.pickupscheduler.utils

import java.util.*

class DateConversions {
	companion object {
		fun getAsString(d: Date): String {
			val cal = getAsCalendar(d)
			return "${cal.get(Calendar.YEAR)}/${cal.get(Calendar.MONTH) + 1}/${cal.get(java.util.Calendar.DAY_OF_MONTH)}"
		}

		fun getAsInt(d: Date): Int {
			val cal = getAsCalendar(d)
			return cal.get(Calendar.YEAR) * 10000 + (cal.get(Calendar.MONTH) + 1) * 100 + cal.get(java.util.Calendar.DAY_OF_MONTH)
		}

		private fun getAsCalendar(d: Date): Calendar {
			val cal = Calendar.getInstance()
			cal.time = d
			return cal
		}
	}
}