module NearApi.Rpc.Types.Common where

import Prelude

import Data.Argonaut.Core (Json, isNumber, isString, toNumber, toString)
import Data.Argonaut.Decode (JsonDecodeError(..))
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.BigInt (BigInt, fromNumber, fromString, toNumber, toString) as BigInt
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (maybe)
import Data.Number (pow)
import Data.Number.Format (precision, toStringWith)

type BlockHash = String

data BlockId
    = BlockNumber Number
    | BlockHash BlockHash

data Finality
    = Optimistic
    | Final

-- Typically calls require a BlockId OR Finality, so lets describe that
data BlockId_Or_Finality
    = BlockId BlockId
    | Finality Finality

type AccountId = String
type PublicKey = String

newtype AmountInYocto = AmountInYocto BigInt.BigInt

derive instance genericAmountInYocto ∷ Generic AmountInYocto _
instance showAmountInYocto ∷ Show AmountInYocto where
    show (AmountInYocto amount) =
        let
            nearAmt ∷ Number
            nearAmt = (BigInt.toNumber amount / (10.0 `pow` 24.0))
        in
            (toStringWith (precision 10) nearAmt) <> "Ⓝ" <> " (" <> BigInt.toString amount <> ")"

-- Allows for decoding of values in strings e.g. "12354" or numbers 12354
instance decodeJsonAmountInYocto ∷ DecodeJson AmountInYocto where
    decodeJson ∷ Json → Either JsonDecodeError AmountInYocto
    decodeJson json =
        if isString json then
            maybe (Left $ UnexpectedValue json) (Right <<< AmountInYocto) (toString json >>= BigInt.fromString)
        else if isNumber json then
            maybe (Left $ UnexpectedValue json) (Right <<< AmountInYocto) (toNumber json >>= BigInt.fromNumber)
        else
            Left $ UnexpectedValue json
-- Right $ AmountInYocto 0.0