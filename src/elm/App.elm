module App where


import Task exposing (Task)
import Signal exposing (Signal, Mailbox)
import Time exposing (..)
import Debug


port worker : Signal (Task x ())
port worker =
    Signal.map (sendTick tickMailbox.address) (every second)


sendTick : Signal.Address Time -> Time -> (Task x ())
sendTick address time =
    let
      _ = Debug.log "Hello from Elm " time
    in
      Signal.send address time


tickMailbox : Signal.Mailbox Time
tickMailbox =
    Signal.mailbox 0


port tick : Signal Time
port tick =
    tickMailbox.signal
