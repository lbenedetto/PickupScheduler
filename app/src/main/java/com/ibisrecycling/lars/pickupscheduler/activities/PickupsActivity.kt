package com.ibisrecycling.lars.pickupscheduler.activities

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.TextView
import com.ibisrecycling.lars.pickupscheduler.R
import com.ibisrecycling.lars.pickupscheduler.utils.BoundingBox
import com.ibisrecycling.lars.pickupscheduler.utils.Customer
import com.ibisrecycling.lars.pickupscheduler.utils.CustomerManager
import com.ibisrecycling.lars.pickupscheduler.utils.Point
import java.util.*

class PickupsActivity : AppCompatActivity() {
	private lateinit var customerManager: CustomerManager
	private lateinit var customers: Array<Customer>
	private var customerGroups = arrayOf<ArrayList<Customer>>()
	private lateinit var description: TextView
	private var currentGroupNum = 0

	companion object {
		const val GROUP_SIZE: Double = 4.0
		const val MAX_ITERATIONS = 1000
	}

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_pickups)
		customerManager = CustomerManager(applicationContext)
		description = findViewById(R.id.textViewDescription)
		//TODO: Load the map
		customers = customerManager.todaysCustomers.toTypedArray()
		if (customers.isNotEmpty()) customerGroups = generateGroups()
		initGroup()


		findViewById<Button>(R.id.buttonDirections).setOnClickListener {
			//TODO: get directions
		}

		findViewById<Button>(R.id.buttonDone).setOnClickListener {
			currentGroupNum++
			initGroup()
		}
	}

	private fun initGroup() {
		//TODO: Update the map
		updateDescription()
	}

	private fun updateDescription() {
		val size =
				if (customerGroups.isNotEmpty() && customerGroups.size > currentGroupNum)
					customerGroups[currentGroupNum].size
				else
					0
		description.text = getString(R.string.customer_count, dayOfWeek(), customers.size, size)
	}

	private fun dayOfWeek(): String {
		return when (Calendar.getInstance().get(Calendar.DAY_OF_WEEK) - 1) {
			0 -> "Sunday"
			1 -> "Monday"
			2 -> "Tuesday"
			3 -> "Wednesday"
			4 -> "Thursday"
			5 -> "Friday"
			else -> "Saturday"
		}
	}

	/**
	 * Implements K-Means algorithm to find clusters of customers of size GROUP_SIZE
	 * http://stanford.edu/~cpiech/cs221/handouts/kmeans.html
	 * https://mubaris.com/2017/10/01/kmeans-clustering-in-python/
	 *
	 * @returns A list of groups of customers
	 */
	private fun generateGroups(): Array<ArrayList<Customer>> {
		var iterations = 0
		val k = Math.ceil(customers.size / GROUP_SIZE).toInt()      //Target number of groups
		val box = BoundingBox(customers)                            //The bounding box surrounding all the customers
		var oldCentroids = arrayOfNulls<Point>(k)                   //List of previous centroids to check if we're making progress
		val clusters = arrayOf<ArrayList<Customer>>(ArrayList())    //List of generated clusters so far

		//Initialize the centroids to random points
		val centroids = arrayOfNulls<Point>(k)
		for (i in 0 until k) centroids[i] = box.getRandomPointInBounds()

		//Begin the algorithm
		while (shouldKeepIterating(oldCentroids, centroids, iterations)) {
			oldCentroids = centroids
			iterations++

			//Each customer joins a cluster based on their nearest centroid
			for (i in 0 until customers.size) {
				clusters[customers[i].getNearestCentroid(centroids)].add(customers[i])
			}
			//Move the centroids to the geometric mean of their cluster
			//If nobody joined the cluster, put it somewhere random
			for (i in 0 until centroids.size) {
				centroids[i] =
						if (clusters[i].isEmpty())
							box.getRandomPointInBounds()
						else
							clusters[i].geometricMean()
			}
		}
		return clusters
	}

	/**
	 * @returns a Point representing the geometric mean of this list of Customers
	 */
	private fun ArrayList<Customer>.geometricMean(): Point {
		var productX = 1.0
		var productY = 1.0
		for (c in this) {
			productX *= c.x
			productY *= c.y
		}
		return Point(Math.pow(productX, 1.0 / this.size), Math.pow(productY, 1.0 / this.size))
	}

	private fun shouldKeepIterating(oldCentroids: Array<Point?>, centroids: Array<Point?>, iterations: Int): Boolean {
		return (iterations < MAX_ITERATIONS) && (!oldCentroids.contentEquals(centroids))
	}

	/**
	 * Finds the closest centroid to this customer
	 * @param centroids The list of centroids to measure distance to
	 * @returns the index of the closest centroid
	 */
	private fun Customer.getNearestCentroid(centroids: Array<Point?>): Int {
		var min = centroids[0]!!.distanceTo(this.location)
		var ix = 0
		var dist: Double
		for (i in 1 until centroids.size) {
			dist = centroids[i]!!.distanceTo(this.location)
			if (dist < min) {
				min = dist
				ix = i
			}
		}
		return ix
	}


}