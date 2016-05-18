import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Json.Encode as Encode
import Json.Decode as Decode
import Array
import String
import Dict



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


echoServer : String
echoServer =
  "ws://localhost:4000/socket/websocket"



-- MODEL


type alias Model =
  { stats : List Float }


init : (Model, Cmd Msg)
init =
  (Model [], Cmd.none)



-- UPDATE


type Msg
  = NewStat String
  | Subscribe


update : Msg -> Model -> (Model, Cmd Msg)
update msg {stats} =
  case msg of
    NewStat str ->
      (Model (pushStat str stats), Cmd.none)

    Subscribe ->
      (Model stats, WebSocket.send echoServer joinPayload)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewStat


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [onClick Subscribe] [text "Subscribe to Data Feed"]
    , div [] (List.map viewStat model.stats)
    ]

viewStat : Float -> Html msg
viewStat msg =
  div [] [ text (toString msg) ]


-- HELPERS


pushStat : String -> List Float -> List Float
pushStat str arr =
  let
    stat =
      parseResponse str
  in
    List.take 30 (stat :: arr)

joinPayload : String
joinPayload =
  let
    object =
      Encode.object
        [ ("topic", Encode.string "monitor:memory")
        , ("event", Encode.string "phx_join")
        , ("payload", Encode.string "")
        , ("ref", Encode.string "")
        ]
  in
    Encode.encode 0 object

parseResponse : String -> Float
parseResponse str =
  let
    stat =
      Decode.decodeString responseStat str
      |> Result.withDefault "0"

  in
    Result.withDefault 0 (String.toFloat stat)

responseStat : Decode.Decoder String
responseStat =
  Decode.at ["payload", "stat"] Decode.string











