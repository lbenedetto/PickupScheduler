package com.ibisrecycling.lars.pickupscheduler.utils

class BoundingBox(customers: Array<Customer>) {
	private var minX: Double
	private var maxX: Double
	private var minY: Double
	private var maxY: Double

	init {
		minX = customers[0].x
		maxX = customers[0].x
		minY = customers[0].y
		maxY = customers[0].y

		for (c in customers) {
			minX = if (c.x < minX) c.y else minX
			maxX = if (c.x > maxX) c.y else maxX
			minY = if (c.x < minY) c.y else minY
			maxY = if (c.x > maxY) c.y else maxY
		}
	}

	private fun Double.isOutOfBoundsX(): Boolean = this > maxX || this < minX
	private fun Double.isOutOfBoundsY(): Boolean = this > maxY || this < minY

	fun getRandomPointInBounds(): Point {
		var x: Double
		var y: Double
		do {
			x = Math.random()
		} while (x.isOutOfBoundsX())
		do {
			y = Math.random()
		} while (y.isOutOfBoundsY())
		return Point(x, y)
	}
}