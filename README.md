# Instagram

Xcode 9.2 required

Pages:

* Login:<br>
  * Checks in Firebase database if user exists if it does presents user profile

* Signup:<br>
  * Set profile image from phone gallery
  * Checks if all fields are filled to allow you to sign up
  * Sends data and image to Firebase database and storage and present user profile

* User Profile:<br>
  * In the upper right corner log out option
  * Presents user profile image, user name, and all posts 
  * Posts load async
  
* Likes

* Add Post:<br>
  * Ask user to access photos
  * Present photos with prview 
  * By taping on next the comment view is presented 
  * Type the comment 
  * Post button sends image and comment to database and presents the post in home and user profile

* Search:<br>
  * Search all user that are in database by name
  * Open their profile
  * If you tap follow that user is added in your following list in database and their posts are presented in your home screen

* Home:<br>
  * See all your posts and posts of all users that you are following
  * Async loading of the posts
  * Liking posts of other users
  * Post commetns to other users
  * In the upper left corner is the camera button(now it looks like paper plane) it opens custom camera(only one device) with 
  manual zoom slider, manual brightness slider, and manual focus slider.
  * All the posts have time stamp time passed since posted
  * Refreshing page by pulling down 
  * Return to top by taping on home ico in tab bar
  * Open user profile by taping on the header of the post
