module Test.Records where

import Prelude

import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode.Class (class EncodeJson, class GEncodeJson, encodeJson)
import Prim.RowList (class RowToList, RowList)
import Record as Record

type Smooshed p = ( f1 :: String | p )

gg :: forall p. EncodeJson (Record (Smooshed p)) => Record p -> Json
gg params = 
    let template = { f1 : "field from template" }
        smooshed = Record.union template params
        jsoned = encodeJson smooshed
    in jsoned
