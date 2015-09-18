module Watchface where


import Time exposing (..)
import Task exposing (Task)
import Signal exposing (Signal, Mailbox)
import Effects exposing (Effects, Never)
import Json.Decode exposing (list, string, int)
import Http
import Debug

import StartPebble exposing (..)


{- API -}


app : StartPebble.App Model
app =
    StartPebble.start <|
            StartPebble.Config
                    (init, Effects.task requestWeatherData)
                    update
                    [tickSignal]


requestWeatherData : Task never Action
requestWeatherData =
    let
        baseRequest =
            Http.get (Json.Decode.at ["main", "temp"] int) "http://api.openweathermappp.org/data/2.5/weather?q=Tokyo"

        actionRequest =
            Task.map Temp baseRequest
    in
      -- onError : Task x a -> (x -> Task y a) -> Task y a
      Task.onError actionRequest (\error -> (Task.succeed (TempError (toString error))))


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
    { time : Time
    , temp : Int
    }


init =
    { time = 0
    , temp = 0
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
      Temp temp ->
          let
              _ = Debug.log "Temp " temp
          in
            { model | temp <- temp } => Effects.none
      TempError error ->
          let
              _ = Debug.log "ERROR Temp" error
          in
            model => Effects.none


type Action
    = NoOp
    | Tick Time
    | Temp Int
    | TempError String


{- icings -}


(=>) : a -> b -> (a, b)
(=>) = (,)
