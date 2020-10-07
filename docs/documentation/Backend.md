# Backend (Spring Boot + Kotlin)
## Users
### Register / login (NO AUTHENTICATION NEEDED)
Users can register / login in the app via OAuth. When they do, an `access token` and `id token` will be sent to the backend. The backend will verify the tokens and get the necessary information out of the tokens, the oauth `provider` and `id` from the `access token`, and the `name` and `email` from the `id token`. If there already is a user with the given id, we suppose that the user has registered before and log the user in, otherwise we register it as a new user with the given data from the tokens.

### Get current user
Get the current logged in user, which is based on the given access token. The oauth `provider` and `id` wil be extracted from the `access token`, after which we'll seek the user and return it if it has been found.

### Update user
Update the user, and with user we mean the currently logged in user. We retrieve the user as described above, modify the user with the given values and save it to the database, after which the updated user will be returned.

### Delete user
Delete the user, and with user we mean the currently logged in user. We retrieve the user as described above, delete it and return a `204 no content` if successful.

### Get sensors
Get all sensors that are connected to the currently logged in user. We retrieve the user as described in `Get current user`, and then check which sensors are connected to the user. Because it is a many to many relationship, multiple users could own the same sensor. This is done to ensure that family members don't need to log in via 1 account, but could all have their own accounts.

## Sensors
### Get all sensors
Get all sensors that are in the database. This call supports projections, so if you, for example, append `?projection=simple` to the url, you'll get a list of sensors without unnecessary data. 

### Get sensor by UUID
Get a sensor by UUID. This will return the sensor and also contains all users that own the sensor.

### Verify sensor by UUID (NO AUTHENTICATION NEEDED)
Verify that a sensor with the given UUID exists, used as verification step in the app to ensure that the user has a genuine sensor. This, of course, requires this endpoint to be publicly accessible without any authentication.

## Notes
### Get notes by data point ID
Get all notes that are created for a specific data point id. All data point ids come from the lectoraat backend, not this backend. We do store the data point id in our backend so the app can query for any data point id he likes and we'll check whether we have any data of it.

### Get notes by monitoring well ID
Get all notes that are created for a specific monitoring well id. All data point ids come from the lectoraat backend, not this backend. We do store the monitoring well id in our backend so the app can query for any monitoring well id he likes and we'll check whether we have any data of it.

### Create note
Create a note for a specific data point and monitoring well. The user can enter a description, which will be saved and can later on be retrieved based on the data point id / monitoring well id. After the note is successfully created, it will be returned so the user can use it.

### Update note
Update a note based on the given note id and the description

### Delete note
Delete a note based on the given note id

# Class Diagram
<img alt="Class Diagram" src="../images/Backend%20Class%20Diagram.svg">