
html ->

    head ->
        title "#{@title} | Grillode"
        link rel: "stylesheet", href: "/style.css"
        script src: "http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"
        script src: "http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js"
        script src: "/socket.io/socket.io.js"
        script src: "/client.coffee"

    body class: "room", ->
        div  id: "messages"
        ul   id: "users"
        form id: "input", ->
            input
                type: "hidden"
                name: "room"
                id: "room"
                value: @room
            input
                type: "text"
                class: "text"
                name: "message"
                id: "message"
                value: "Please enter your name"
            input
                type: "submit"
                name: "button"
                id: "button"
                value: "Join"
            input
                type: "button"
                name: "leave"
                id: "leave"
                value: "Leave"
