
express = require "express"
util    = require "./util.coffee"


# Tag/attribs mapping of allowed tags and attributes.
allowedTags = 
    b       : []
    i       : [] 
    img     : ["src"]
    a       : ["href"] 
    center  : []
    font    : ["face", "color", "size"]

# Global list of client connections.
_clients = []

# Adds a client to the global client list.
add = (client) -> _clients.push client

# Removes a client from the global client list.
remove = (client) -> delete _clients[_clients.indexOf client]

# Returns true if the given client is logged in with a name.
valid = (client) -> client.name?

# Return connections that have a valid name assigned.
clients = -> _clients.filter valid

# Send the given string of data to all valid clients.
broadcast = (data) -> c.send "[#{util.time()}] #{data}" for c in clients()


# Set up the express app.
app = express.createServer()
app.use express.staticProvider root: "#{__dirname}/public"
app.set "view options", layout: off

app.get "/client.coffee", (req, res) ->
    res.header "Content-Type", "text/plain"
    res.send util.coffeeCompile "client.coffee"

app.get "/", (req, res) ->
    res.render "index.ejs"

app.listen 8000


# Set up socket.io events.
((require "socket.io").listen app).on "connection", (client) ->

    # Add client to the global list when connected.
    add client

    client.on "message", (data) ->
        if not valid client
            # Client has not yet entered a name.
            name = util.stripTags data
            if not name or clients().some ((c) -> c.name is name)
                # Name given is already in use.
                client.send "Name is in use, please enter another"
            else
                # Set the client's name and send the join message.
                client.name = name
                client.displayName = util.stripTags data, allowedTags
                broadcast "#{client.displayName} joins"
        else
            # Client sent a message.
            message = util.stripTags data, allowedTags
            broadcast "#{client.displayName}: #{message}"

    client.on "disconnect", ->
        # On disconnect, send the leave message and remove the client 
        # from the global client list.
        broadcast "#{client.displayName} leaves"
        remove client
