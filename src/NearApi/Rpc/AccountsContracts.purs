module NearApi.Rpc.AccountsContracts where

import Prelude

import Data.List (List)
import Data.Maybe (Maybe)
import NearApi.Rpc.Client (RpcCall, addBlockIdOrFinality, resultOf, rpc)
import NearApi.Rpc.Types.Common (BlockId_Or_Finality, AccountId)

type ViewAccountParams =
    { account_id :: AccountId
    }

type ViewAccountResult = 
    { amount :: String
    , locked :: String
    , code_hash :: String
    , storage_usage :: Number
    , storage_paid_at :: Number
    , block_height :: Number
    , block_hash :: String
    }

view_account :: BlockId_Or_Finality -> ViewAccountParams -> RpcCall ViewAccountResult
view_account blockid_or_finality params =
    resultOf <<< 
        rpc "query" (addBlockIdOrFinality blockid_or_finality) 
            { request_type : "view_account" 
            , account_id : params.account_id
            }

type AccountChangesParams =
    { account_ids :: List String 
    }

type AccountChangesResult =
    { changes :: List 
        { cause :: 
            { type :: String
            , tx_hash :: Maybe String 
            }
        , type :: String
        , change :: 
            { account_id :: AccountId
            , amount :: String
            , locked :: String
            , code_hash :: String
            , storage_usage :: Number
            , storage_paid_at :: Number
            }
        }
    }

account_changes :: BlockId_Or_Finality -> AccountChangesParams -> RpcCall AccountChangesResult
account_changes blockid_or_finality params =
    resultOf <<< 
        rpc "EXPERIMENTAL_changes" (addBlockIdOrFinality blockid_or_finality) 
            { changes_type : "account_changes" 
            , account_ids : params.account_ids
            }

type ViewCodeParams =
    { account_id :: AccountId
    }

type ViewCodeResult =
    { code_base64 :: String
    , hash :: String
    , block_height :: Number
    , block_hash :: String
    }

view_code :: BlockId_Or_Finality -> ViewCodeParams -> RpcCall ViewCodeResult
view_code blockid_or_finality params =
    resultOf <<< 
        rpc "query" (addBlockIdOrFinality blockid_or_finality) 
            { request_type : "view_code" 
            , account_id : params.account_id
            }

type ViewStateParams =
    { account_id :: AccountId
    , prefix_base64 :: String
    }

type ViewStateResult =
    { values :: List
        { key :: String
        , value :: String
        , proof :: List String
        }
    }

view_state :: BlockId_Or_Finality -> ViewStateParams -> RpcCall ViewStateResult
view_state blockid_or_finality params =
    resultOf <<< 
        rpc "query" (addBlockIdOrFinality blockid_or_finality) 
            { request_type : "view_state" 
            , account_id : params.account_id
            , prefix_base64 : params.prefix_base64
            }

type DataChangesParams =
    { account_ids :: List AccountId
    , key_prefix_base64 :: String
    }

type DataChangesResult =
    { changes :: List 
        { cause :: 
            { type :: String
            , receipt_hash :: Maybe String 
            }
        , type :: String
        , change :: 
            { account_id :: AccountId
            , key_base64 :: String
            , value_base64 :: String
            }
        }
    }

data_changes :: BlockId_Or_Finality -> DataChangesParams -> RpcCall DataChangesResult
data_changes blockid_or_finality params =
    resultOf <<< 
        rpc "EXPERIMENTAL_changes" (addBlockIdOrFinality blockid_or_finality) 
            { changes_type : "data_changes" 
            , account_ids : params.account_ids
            , key_prefix_base64 : params.key_prefix_base64
            }

type ContractCodeChangesParams =
    { account_ids :: List AccountId
    }

type ContractCodeChangesResult =
    { changes :: List 
        { cause :: 
            { type :: String
            , receipt_hash :: Maybe String 
            }
        , type :: String
        , change :: 
            { account_id :: AccountId
            , code_base64 :: String
            }
        }
    }

contract_code_changes :: BlockId_Or_Finality -> ContractCodeChangesParams -> RpcCall ContractCodeChangesResult
contract_code_changes blockid_or_finality params =
    resultOf <<< 
        rpc "EXPERIMENTAL_changes" (addBlockIdOrFinality blockid_or_finality) 
            { changes_type : "contract_code_changes" 
            , account_ids : params.account_ids
            }

type CallFunctionParams =
    { account_id :: AccountId
    , method_name :: String
    , args_base64 :: String
    }

type CallFunctionResult =
    { result :: List Int
    , logs :: List String
    , block_height :: Number
    , block_hash :: String
    }

call_function :: BlockId_Or_Finality -> CallFunctionParams -> RpcCall CallFunctionResult
call_function blockid_or_finality params =
    resultOf <<< 
        rpc "query" (addBlockIdOrFinality blockid_or_finality) 
            { request_type : "call_function" 
            , account_id : params.account_id
            , method_name : params.method_name
            , args_base64 : params.args_base64
            }