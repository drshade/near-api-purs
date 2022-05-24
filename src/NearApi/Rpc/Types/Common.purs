module NearApi.Rpc.Types.Common where

import Prelude

import Data.Argonaut.Core (fromNumber, fromString)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Int (toNumber)

type BlockHash = String

data BlockId 
    = BlockNumber Number
    | BlockHash   BlockHash

data Finality
    = Optimistic
    | Final

-- Typically calls require a BlockId OR Finality, so lets describe that
data BlockId_Or_Finality
    = BlockId  BlockId
    | Finality Finality

type AccountId = String
type PublicKey = String
