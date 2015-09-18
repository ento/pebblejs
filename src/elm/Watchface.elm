module Watchface where


import Time exposing (..)
import Task exposing (Task)
import Signal exposing (Signal, Mailbox)
import Effects exposing (Effects, Never)
import Debug

import StartPebble exposing (..)


{- API -}


app : StartPebble.App Model
app =
    StartPebble.start <|
            StartPebble.Config
                    (init, Effects.none)
                    update
                    [tickSignal]


tickSignal : Signal Action
tickSignal =
    Signal.map Tick (every second)


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks


port model : Signal Model
port model =
    app.model


{- Model -}


type alias Model =
    { time : Time }


init =
    { time = 0
    }


{- Update -}


update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
      NoOp ->
          model => Effects.none
      Tick time ->
          let
              _ = Debug.log "Hello from Elm " time
          in
            { model | time <- time } => Effects.none


type Action
    = NoOp
    | Tick Time


{- icings -}


(=>) : a -> b -> (a, b)
(=>) = (,)
