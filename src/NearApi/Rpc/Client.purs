module NearApi.Rpc.Client where

import Prelude

import Affjax (Error, Response, printError) as Affjax
import Affjax.Node (post) as AffjaxNode
import Affjax.RequestBody (json) as RequestBody
import Affjax.ResponseFormat (json) as ResponseFormat
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import NearApi.Rpc.AccessKeys (ViewAccessKeyRes)
import NearApi.Rpc.JsonRpc (JsonRpcRequest, JsonRpcResponseError, JsonRpcResponseResultError, JsonRpcResponse)
import NearApi.Rpc.Network (NetworkConfig, mainnet, testnet)
import Record as Record

data ClientError
    = TransportError String
    | RpcError String
    | MethodError String
    | UnexpectedResponseError String

derive instance genericClientError :: Generic ClientError _
instance showClientError :: Show ClientError where show = genericShow

rpc_request network method method_params =
    let rpc =   { jsonrpc : "2.0"
                , id : "dontcare"
                , method : "query"
                , params : 
                    { request_type : method
                    , finality : "final"
                    }
                }
        merged_envelope = rpc { params = Record.union rpc.params method_params }
    in call network merged_envelope

view_access_keys' :: NetworkConfig -> Aff (Either ClientError { result :: ViewAccessKeyRes })
view_access_keys' network = 
    rpc_request network "view_access_key"
        { account_id : "tomwells.testnet"
        , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
        }

view_access_keys :: Aff (Either ClientError { result :: ViewAccessKeyRes })
view_access_keys = 
    let rpc =   { jsonrpc : "2.0"
                , id : "dontcare"
                , method : "query"
                , params : 
                    { request_type : "view_access_key"
                    , finality : "final"
                    }
                }
        r =     { account_id : "tomwells.testnet"
                , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
                }

        m = rpc { params = Record.union rpc.params r }
    in call testnet m

decodeResponse :: forall a. DecodeJson a => Either Affjax.Error (Affjax.Response Json) -> Either ClientError a
-- An error at the Affjax level (transport / DNS etc)
decodeResponse (Left err) = Left $ TransportError $ Affjax.printError err
-- We got a response
decodeResponse (Right { body : bodyjson }) =
    -- Try to parse the various "error" shaped types from the response
    -- plus the one we are expecting
    let error_result_rpc :: Either JsonDecodeError JsonRpcResponseError
        error_result_rpc = decodeJson bodyjson
        error_result_method :: Either JsonDecodeError JsonRpcResponseResultError
        error_result_method = decodeJson bodyjson
        expected_result :: Either JsonDecodeError a
        expected_result = decodeJson bodyjson
    in
    -- Which one worked?
    case Tuple error_result_rpc error_result_method of
        -- Error from the RPC envelope level
        Tuple (Right err) _ -> Left $ RpcError $ err.error.message <> " (caused by -> " <> err.error.cause.info.error_message <> ")"
        -- Error from the Method envelope level
        Tuple _ (Right err) -> Left $ MethodError $ err.result.error
        -- Cool, so try the expected one
        Tuple (Left _) (Left _) -> 
            case expected_result of
                -- Failed to decode the expected response
                Left err -> Left $ UnexpectedResponseError $ show err
                -- All good
                Right b -> Right b

call :: forall req res. EncodeJson req => DecodeJson res => NetworkConfig -> req -> Aff (Either ClientError res)
call network req =
    let encodedRequestBody :: Json
        encodedRequestBody = encodeJson req
    in do
        rpcRes :: Either Affjax.Error (Affjax.Response Json) <- AffjaxNode.post ResponseFormat.json network.rpc $ Just $ RequestBody.json encodedRequestBody
        pure $ decodeResponse rpcRes

