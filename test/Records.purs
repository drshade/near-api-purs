module Test.Records where

import Prelude

import Data.Argonaut.Core (Json, fromNumber, fromObject, fromString, toObject)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Maybe (Maybe(..))
import Foreign.Object (Object, insert)
import Record as Record

type Smooshed p = 
    ( f1 :: String | p )

gg :: forall p. EncodeJson (Record (Smooshed p)) => Record p -> Json
gg params = 
    let template = { f1 : "field from template" }
        smooshed :: Record (Smooshed p)
        smooshed = Record.union template params
        jsoned = encodeJson smooshed
    in jsoned

data SomeOption 
    = Option1 String 
    | Option2 Number

instance encodeJsonSomeOption :: EncodeJson SomeOption where
    encodeJson (Option1 s) = fromString s
    encodeJson (Option2 i) = fromNumber i

type Payload =
    ( stuff :: String
    )

hh :: SomeOption -> Record Payload -> Json
hh option payload =
    let pre1 :: Json
        pre1 = encodeJson payload
        pre2 :: Maybe (Object Json)
        pre2 = toObject pre1
        pre3 :: Maybe (Object Json)
        pre3 = (\o -> insert "bob" (fromNumber 5.0) o) <$> pre2
    in case pre3 of
        Just p -> fromObject p
        Nothing -> pre1
