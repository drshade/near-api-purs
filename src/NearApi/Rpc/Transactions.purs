module NearApi.Rpc.Transactions where

import Prelude

import Data.Argonaut.Core (fromArray, fromString, jsonSingletonArray)
import Data.List (List)
import Data.Maybe (Maybe)
import NearApi.Rpc.Client (RpcCall, addRawParams, noExtras, resultOf, rpc)
import NearApi.Rpc.Types.Common (AccountId, AmountInYocto(..), PublicKey)

type BroadcastTxAsyncParams =
    { signed_transaction_base64 :: String
    }

type BroadcastTxAsyncResult = String

broadcast_tx_async :: BroadcastTxAsyncParams -> RpcCall BroadcastTxAsyncResult
broadcast_tx_async params =
    resultOf <<< 
        rpc "broadcast_tx_async" 
            (addRawParams $ jsonSingletonArray $ fromString params.signed_transaction_base64) 
            {}

type BroadcastTxCommitParams =
    { signed_transaction_base64 :: String
    }

type BroadcastTxCommitResult = 
    { status :: 
        { "SuccessReceiptId" :: Maybe String
        , "SuccessValue" :: Maybe String
        }
    , transaction ::
        { signer_id :: AccountId
        , public_key :: PublicKey
        , nonce :: Number
        , receiver_id :: AccountId
        , actions :: List
            { "Transfer" :: Maybe
                { deposit :: AmountInYocto
                }
            , "FunctionCall" :: Maybe
                { method_name :: String
                , args :: String
                , gas :: Number
                , deposit :: AmountInYocto
                }
              -- Could be others?
            }
        , signature :: String
        , hash :: String
        }
    , transaction_outcome :: 
        { proof :: List
            { hash :: String
            , direction :: String
            }
        , block_hash :: String
        , id :: String
        , outcome :: 
            { logs :: List String
            , receipt_ids :: List String
            , gas_burnt :: Number
            , tokens_burnt :: String
            , executor_id :: AccountId
            , status ::
                { "SuccessReceiptId" :: Maybe String
                , "SuccessValue" :: Maybe String
                }
            }
        }
    , receipts_outcome :: List
        { proof :: List
            { hash :: String
            , direction :: String
            }
        , block_hash :: String
        , id :: String
        , outcome :: 
            { logs :: List String
            , receipt_ids :: List String
            , gas_burnt :: Number
            , tokens_burnt :: String
            , executor_id :: AccountId
            , status ::
                { "SuccessReceiptId" :: Maybe String
                , "SuccessValue" :: Maybe String
                }
            }
        }
    -- Only populated by TxStatusWithReceipts
    , receipts :: Maybe (List ReceiptSpec)
    }

type ReceiptSpec =
    { predecessor_id :: AccountId
    , receipt ::
        { "Action" ::
            { actions :: List
                { "Transfer" :: Maybe
                    { deposit :: AmountInYocto
                    }
                , "FunctionCall" :: Maybe
                    { method_name :: String
                    , args :: String
                    , gas :: Number
                    , deposit :: AmountInYocto
                    }
        -- Could be others?
                }
            , gas_price :: String
            , input_data_ids :: List String
            , output_data_receivers :: List
                { data_id :: String
                , receiver_id :: String
                }
            , signer_id :: AccountId
            , signer_public_key :: PublicKey
            }
        }
    , receipt_id :: String
    , receiver_id :: AccountId
    }

broadcast_tx_commit :: BroadcastTxCommitParams -> RpcCall BroadcastTxCommitResult
broadcast_tx_commit params =
    resultOf <<< 
        rpc "broadcast_tx_commit" 
            (addRawParams $ jsonSingletonArray $ fromString params.signed_transaction_base64) 
            {}

type TxParams =
    { transaction_hash :: String
    , sender :: AccountId
    }

type TxResult = BroadcastTxCommitResult

tx :: TxParams -> RpcCall TxResult
tx params =
    resultOf <<< 
        rpc "tx" 
            ( addRawParams 
                $ fromArray 
                $ [ fromString params.transaction_hash
                  , fromString params.sender
                  ]
            ) {}

type TxStatusWithReceiptsParams =
    { transaction_hash :: String
    , sender :: AccountId
    }

type TxStatusWithReceiptsResult = BroadcastTxCommitResult

tx_status_with_receipts :: TxStatusWithReceiptsParams -> RpcCall TxStatusWithReceiptsResult
tx_status_with_receipts params =
    resultOf <<< 
        rpc "EXPERIMENTAL_tx_status" 
            ( addRawParams 
                $ fromArray 
                $ [ fromString params.transaction_hash
                  , fromString params.sender
                  ]
            ) {}

type ReceiptIdParams =
    { receipt_id :: String
    }

type ReceiptIdResult = ReceiptSpec

receipt_id :: ReceiptIdParams -> RpcCall ReceiptIdResult
receipt_id params =
    resultOf <<< 
        rpc "EXPERIMENTAL_receipt" 
            noExtras
            { receipt_id : params.receipt_id
            }