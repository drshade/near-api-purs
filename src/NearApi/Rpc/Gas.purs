module NearApi.Rpc.Gas where

import Prelude

import Data.Argonaut.Core (fromNumber, fromString, jsonNull, jsonSingletonArray)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import NearApi.Rpc.Client (RpcCall, addRawParams, noExtras, resultOf, rpc)

data GasPriceParams
    = GasPriceLatest
    | GasPriceAtBlockHeight Number
    | GasPriceAtBlockHash String

type GasPriceResult =
    { gas_price :: String
    }

gas_price :: GasPriceParams -> RpcCall GasPriceResult
gas_price GasPriceLatest =
    resultOf <<< 
        rpc "gas_price" (addRawParams $ jsonSingletonArray jsonNull)
            { }
gas_price (GasPriceAtBlockHeight block_height) =
    resultOf <<< 
        rpc "gas_price" (addRawParams $ jsonSingletonArray $ fromNumber block_height)
            { }
gas_price (GasPriceAtBlockHash block_hash) =
    resultOf <<< 
        rpc "gas_price" (addRawParams $ jsonSingletonArray $ fromString block_hash)
            { }
