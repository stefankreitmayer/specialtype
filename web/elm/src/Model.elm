module Model exposing (..)

import Dict exposing (Dict)
import String
import List

import Model.Page exposing (Page(..))

type alias Model =
  { currentPage : Page
  , profile : Profile
  , exercise : Maybe Exercise }

type alias Exercise =
  { target : String
  , userInput : String
  , progress : Int }

type alias Profile =
  Dict Char (List Bool)


initialModel : Model
initialModel =
  { currentPage = Home
  , profile = emptyProfile
  , exercise = Nothing }


emptyProfile : Profile
emptyProfile =
  allCharacters
  |> String.toList
  |> List.foldr (\char dict -> Dict.insert char [] dict) Dict.empty


allCharacters : String
allCharacters = "(-_=+*!)@£$%^&[]{};:'\"\\`~,./<>?"


isExerciseComplete : Maybe Exercise -> Bool
isExerciseComplete exercise =
  case exercise of
    Nothing ->
      False

    Just {userInput,target} ->
      String.length userInput >= String.length target
