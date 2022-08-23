module NearApi.Rpc.Client where

import Prelude

import Affjax (Error, Response, printError) as Affjax
import Affjax.Node (post) as AffjaxNode
import Affjax.RequestBody (json) as RequestBody
import Affjax.ResponseFormat (json) as ResponseFormat
import Control.Monad.Except (ExceptT(..), runExceptT)
import Data.Argonaut.Core (Json, fromNumber, fromObject, fromString, stringify, toObject)
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Either (Either(..))
import Data.List (List)
import Data.Maybe (Maybe(..), maybe)
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class.Console (log)
import Foreign.Object (Object, insert, lookup)
import NearApi.Rpc.NetworkConfig (NetworkConfig)
import NearApi.Rpc.Types.Common (BlockId(..), BlockId_Or_Finality(..), Finality(..))

-- RPC Level (low level calls) - totally upto caller to deal with weird shit
-- Build a nicer highlevel thing onto of it (incl. creaing a valid signed tx)

type NearApi a = ExceptT ClientError Aff a

runNearApi ∷ ∀ a. NearApi a → Aff (Either ClientError a)
runNearApi = runExceptT

data ClientError
    = TransportError String
    | RpcError String
    | MethodError String
    | UnexpectedResponseError String String

instance showClientError ∷ Show ClientError where
    show (TransportError err) = "TransportError: " <> err
    show (RpcError err) = "RpcError: " <> err
    show (MethodError err) = "MethodError: " <> err
    show (UnexpectedResponseError err payload) = "UnexpectedResponseError: " <> err <> " Payload: " <> payload

-- derive instance genericClientError :: Generic ClientError _
-- instance showClientError :: Show ClientError where show = genericShow

type RpcCall a = NetworkConfig → NearApi a

-- resultOf :: forall a. Aff (Either ClientError { result :: a }) -> Aff (Either ClientError a)
resultOf ∷ ∀ a. NearApi ({ result ∷ a }) → NearApi a
resultOf x = do
    { result: a } ← x
    pure a

-- If there is an error at the JSON-RPC level
type JsonRpcResponseError =
    { error ∷
          { name ∷ String
          , cause ∷
                { name ∷ String
                -- This bit seems to vary a little - irritatingly!
                -- , info :: 
                --     { error_message :: String 
                --     }
                }
          , code ∷ Int
          , message ∷ String
          , data ∷ String
          }
    }

-- If the succesfully handled call throws an error
type JsonRpcResponseResultError =
    { result ∷
          { error ∷ String
          , logs ∷ List String
          }
    }

decodeResponse ∷ ∀ a. DecodeJson a ⇒ Either Affjax.Error (Affjax.Response Json) → Either ClientError a
-- An error at the Affjax level (transport / DNS etc)
decodeResponse (Left err) = Left $ TransportError $ Affjax.printError err
-- We got a response
decodeResponse (Right { body: bodyjson }) =
    -- Complex, but basically try parse the two different error types from the response first
    case (decodeJson bodyjson ∷ Either JsonDecodeError JsonRpcResponseError) of
        Right errorBody → -- It is an error of type JsonRpcResponseError

            Left $ RpcError
                $ errorBody.error.message <> " (caused by -> " <> errorBody.error.name <> ": " <> errorBody.error.message <> ": " <> errorBody.error.data <> ")"
        Left _ →
            case (decodeJson bodyjson ∷ Either JsonDecodeError JsonRpcResponseResultError) of
                Right errorBody → -- It is an error of type JsonRpcResponseResultError

                    Left $ MethodError
                        $ errorBody.result.error
                Left _ →
                    case (decodeJson bodyjson ∷ Either JsonDecodeError a) of
                        Left errorParsing →
                            Left $ UnexpectedResponseError (show errorParsing) (stringify bodyjson)
                        Right good → Right good

-- This is an exciting signature, but really it's complex because we are 
-- ensuring that the type p is json encodable and that needs some magical 
-- type level (by adding Record to it)
-- the constraint checker needs to be certain that the result satisfies
-- the EncodeJson constraint
rpc
    ∷ ∀ (p ∷ Row Type) (result ∷ Type)
    . EncodeJson (Record p)
    ⇒ DecodeJson result
    ⇒ String
    → (Json → Json)
    → Record p
    → NetworkConfig
    → NearApi result
rpc method addExtras params network =
    let -- The basic JSON-RPC envelope
        rpcEnvelope =
            { jsonrpc: "2.0"
            , id: "dontcare"
            , method
            , params
            }
        rpcEnvelopeEncoded = addExtras $ encodeJson rpcEnvelope

    in
        ExceptT $ liftAff do
            response ← AffjaxNode.post ResponseFormat.json network.nodeUrl $ Just $ RequestBody.json $ rpcEnvelopeEncoded
            -- log $ stringify rpcEnvelopeEncoded
            pure $ decodeResponse response

noExtras ∷ Json → Json
noExtras x = x

-- Basically add either "block_id" or "finality" to the params of JSON provided
-- and encode correctly according to NEAR spec (either string or number for block_id)
addBlockIdOrFinality ∷ BlockId_Or_Finality → Json → Json
addBlockIdOrFinality blockid_or_finality input =
    let
        patch ∷ Object Json → Object Json
        patch =
            case blockid_or_finality of
                BlockId (BlockNumber number) → insert "block_id" (fromNumber number)
                BlockId (BlockHash hash) → insert "block_id" (fromString hash)
                Finality Optimistic → insert "finality" (fromString "optimistic")
                Finality Final → insert "finality" (fromString "final")

        -- Very crude - but effectively patch the function above into the .params
        -- (dealing with maybes everywhere)
        patched ∷ Maybe (Object Json)
        patched = do
            objInput ∷ Object Json ← toObject input
            params ∷ Json ← lookup "params" objInput
            objParams ∷ Object Json ← toObject params

            pure $ insert "params" (fromObject $ patch objParams) objInput
    in
        maybe input fromObject patched

addRawParams ∷ Json → Json → Json
addRawParams replacement input =
    maybe input (fromObject <<< insert "params" replacement) (toObject input)