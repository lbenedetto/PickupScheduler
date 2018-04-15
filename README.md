# PickupScheduler
This is an app I made for my recycling collection company, [Ibis Recycling](https://www.ibisrecycling.com/).
I also made it to familiarize myself with Kotlin, and cross platform development with Flutter

This app imports a list of customers, their addresses, and their subscription type and uses this information to populate a calendar of all scheduled pickups.

On pickup day, the app uses K-Means cluster analysis to pick groups of customers who live close to eacother, 
and then plan a route from the users current location to all the customers in the group, and then to the recycling center.

<img src="https://i.imgur.com/pWhRFp6.png" alt="Schedule Screen" width="250">
<img src="https://i.imgur.com/7vfXlk6.png" alt="Customer List Screen" width="250">
