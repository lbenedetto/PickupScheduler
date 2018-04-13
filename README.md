# PickupScheduler
This is an app I made for my recycling collection company, [Ibis Recycling](https://www.ibisrecycling.com/).
I also made it to familiarize myself with Kotlin

This app internally maintains a list of customers, their addresses, and their subscription type. 
It uses this information to populate a calendar of all scheduled pickups.

On pickup day, the app uses K-Means cluster analysis to pick groups of customers who live close to eacother, 
and then plan a route from the users current location to all the customers in the group, and then to the recycling center.
