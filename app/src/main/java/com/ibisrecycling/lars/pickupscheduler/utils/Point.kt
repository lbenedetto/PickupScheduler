package com.ibisrecycling.lars.pickupscheduler.utils

class Point(val x: Double, val y: Double) {
	fun distanceTo(p: Point): Double {
		return Math.sqrt(Math.pow(x - p.x, 2.0) - Math.pow(y - p.y, 2.0))
	}
}