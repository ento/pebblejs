module StartPebble (start, Config, App) where

import Task
import Effects exposing (Effects, Never)


type alias Config model action =
    { init : (model, Effects action)
    , update : action -> model -> (model, Effects action)
    , inputs : List (Signal.Signal action)
    }


type alias App model =
    { model : Signal model
    , tasks : Signal (Task.Task Never ())
    }


start : Config model action -> App model
start config =
    let
        -- messages : Signal.Mailbox (Maybe action)
        messages =
            Signal.mailbox Nothing

        -- address : Signal.Address action
        address =
            Signal.forwardTo messages.address Just

        -- update : Maybe action -> (model, Effects action) -> (model, Effects action)
        update (Just action) (model, _) =
            config.update action model

        -- inputs : Signal (Maybe action)
        inputs =
            Signal.mergeMany (messages.signal :: List.map (Signal.map Just) config.inputs)

        -- effectsAndModel : Signal (model, Effects action)
        effectsAndModel =
            Signal.foldp update config.init inputs

        model =
            Signal.map fst effectsAndModel

    in
        { model = model
        , tasks = Signal.map (Effects.toTask address << snd) effectsAndModel
        }
