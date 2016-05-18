# ElmMon

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now fire up elm-reactor:

  * cd to client folder `cd client`
  * start elm reactor `elm reactor`

Now visit [`localhost:8000/ws.elm`](http://localhost:8000/ws.elm) from your browser, and click
on the button to subscribe to the data feed.

The Phoenix app provides a genserver which pushes the erlang memory use stat downstream,
and the elm app displays the last 30 memory stats

TODO:
1. Graph this output with elm-svg
2. Rather than pushing stats downstream, request them from client in order
to control update frequency from client
