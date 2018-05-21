# PathNote
Location-based messaging app for iphone

Every user can create an account that has a username and password, these accounts can create posts
Posts have a message, longitude/latitude coordinates, lifespan, and author's username
The user can directly customize the message and lifespan of the post through the interface but not the location or author username
Post coordintes are drawn from the user's location at the time of posting
Posts will be automatically deleted after the lifespan that was set has expired, this is to ensure areas dont get over-cluttered over time and that active posts have some relevancy
User can view any user messages that have not expired yet and were posted within 1 km of their current location (distance may change during development)
User can delete their own posts before its lifespan has expired
User can report posts that are not appropriate
A post will be automatically removed if it is reported 5 times (temporary amount that is likely to change)
