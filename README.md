# Bond API Doc
This document contains the endpoints of the API, request and response structures.
## Status codes (for now)
200: OK
404: Not found
500: Server error

## Endpoints
The base url is: **working on it**. Every endpoint contains this. 
A JSON object is needed in the body of POST and PUT requests.
A unique ID is automagically generated for every model object, it can be accessed through the `id` property.
### User
##### Get
`./users`: returns every user
`./users/:id`: returns the user for the given ID.
##### Post
`./users`: posts a user
body: 
```javascript
[
    {
        name: String,
	    email: String,
	    password: String
    }
]
```
### Category
##### Get
`./category`: returns every category
`./category/:id` : returns the category for the given ID.
##### Post
`./category`: posts a category
body: 
```javascript
[
    {
        name: String,
	    thumbnail_url: String
    }
]
```
### Event
##### Get
`./events`: returns every event
`./events/:id` : returns the event for the given ID.
##### Post
`./events`: posts an event
body: 
```javascript
[
    {
        creator_id: String,
    	category: { 
            name: String,
            thumbnail_url: String
        },
	    date: String,
	    time: String,
	    attendees_count: Number, (Int)
	    max_attendees: Number, (Int)
    }
]
```