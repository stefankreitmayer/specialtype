module Model exposing (..)

import Dict exposing (Dict)
import String
import List

import Model.Page exposing (Page(..))

type alias Model =
  { currentPage : Page
  , profile : Profile }

type alias Profile =
  Dict Char Score

type alias Score =
  { hits : Int
  , misses : Int }


initialModel : Model
initialModel =
  { currentPage = Home
  , profile = emptyProfile }


emptyProfile : Profile
emptyProfile =
  "!@£$%^&*()-_=+[]{};:'\"\\`~,./<>?"
  |> String.toList
  |> List.foldr (\char dict -> Dict.insert char (Score 0 0) dict) Dict.empty
