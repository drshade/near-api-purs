module NearApi.Rpc.Client where

import Prelude

import Affjax (Error, Response, printError) as Affjax
import Affjax.Node (post) as AffjaxNode
import Affjax.RequestBody (json) as RequestBody
import Affjax.ResponseFormat (json) as ResponseFormat
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import NearApi.Rpc.NetworkConfig (NetworkConfig)

data ClientError
    = TransportError String
    | RpcError String
    | MethodError String
    | UnexpectedResponseError String String

derive instance genericClientError :: Generic ClientError _
instance showClientError :: Show ClientError where show = genericShow

type RpcCall a = NetworkConfig -> Aff (Either ClientError a)

resultOf :: forall a. Aff (Either ClientError { result :: a }) -> Aff (Either ClientError a)
resultOf x = x >>= (\y -> pure $ (_.result) <$> y)

-- If there is an error at the JSON-RPC level
type JsonRpcResponseError =
    { error :: 
        { name :: String
        , cause :: 
            { name :: String
            , info :: 
                { error_message :: String 
                }
            }
        , code :: Int
        , message :: String
        , data :: String
        }
    }

-- If the succesfully handled call throws an error
type JsonRpcResponseResultError = 
    { result ::  
        { error :: String
        , logs :: List String 
        }
    }

decodeResponse :: forall a. DecodeJson a => Either Affjax.Error (Affjax.Response Json) -> Either ClientError a
-- An error at the Affjax level (transport / DNS etc)
decodeResponse (Left err) = Left $ TransportError $ Affjax.printError err
-- We got a response
decodeResponse (Right { body : bodyjson }) =
    -- Complex, but basically try parse the two different error types from the response first
    case (decodeJson bodyjson :: Either JsonDecodeError JsonRpcResponseError) of
        Right errorBody -> -- It is an error of type JsonRpcResponseError
            Left $ RpcError 
                 $ errorBody.error.message <> " (caused by -> " <> errorBody.error.cause.info.error_message <> ")"
        Left _ ->
            case (decodeJson bodyjson :: Either JsonDecodeError JsonRpcResponseResultError) of
                Right errorBody -> -- It is an error of type JsonRpcResponseResultError
                    Left $ MethodError 
                         $ errorBody.result.error
                Left _ ->
                    case (decodeJson bodyjson :: Either JsonDecodeError a) of
                        Left errorParsing -> Left $ UnexpectedResponseError (show errorParsing) (stringify bodyjson)
                        Right good -> Right good


-- This is an exciting signature, but really it's complex because we are 
-- ensuring that the type p is json encodable and that needs some magical 
-- type level (by adding Record to it)
-- the constraint checker needs to be certain that the result satisfies
-- the EncodeJson constraint
rpc :: forall (p :: Row Type) (result :: Type).
        EncodeJson (Record p) =>
        DecodeJson result =>
        String -> Record p -> NetworkConfig -> Aff (Either ClientError result)
rpc method params network =
    let -- The basic JSON-RPC envelope
        rpcEnvelope = 
            { jsonrpc : "2.0"
            , id : "dontcare"
            , method
            , params
            }
    in do
        -- Make the network call as json in and out
        response :: Either Affjax.Error (Affjax.Response Json) 
            <- AffjaxNode.post ResponseFormat.json network.rpc $ Just $ RequestBody.json $ encodeJson rpcEnvelope
        -- Decode any errors, or grab the result
        pure $ decodeResponse response

