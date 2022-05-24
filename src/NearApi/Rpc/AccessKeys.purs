module NearApi.Rpc.AccessKeys where

import Prelude

import Data.Argonaut.Encode (class EncodeJson)
import Data.List (List)
import Data.Maybe (Maybe(..))
import NearApi.Rpc.Client (RpcCall, addBlockIdOrFinality, noExtras, resultOf, rpc)
import NearApi.Rpc.Types.Common (BlockId(..), BlockId_Or_Finality(..), Finality, PublicKey, AccountId)
import NearApi.Rpc.Types.Permissions (Permission)
import Prim.Row (class Union)
import Record as Record


type ViewAccessKeyParams =
    { account_id :: AccountId
    , public_key :: PublicKey
    }

type ViewAccessKeyResult = 
    { permission :: Permission 
    }

view_access_key :: BlockId_Or_Finality -> ViewAccessKeyParams -> RpcCall ViewAccessKeyResult
view_access_key blockid_or_finality params =
    resultOf <<< 
        rpc "query" (addBlockIdOrFinality blockid_or_finality) 
            { request_type : "view_access_key" 
            , account_id : params.account_id
            , public_key : params.public_key
            }

type ViewAccessKeyListParams =
    { account_id :: AccountId
    }

type ViewAccessKeyListResult =
    { keys :: List 
        { public_key :: PublicKey
        , access_key :: 
            { permission :: Permission
            }
        }
    }

view_access_key_list :: BlockId_Or_Finality -> ViewAccessKeyListParams -> RpcCall ViewAccessKeyListResult
view_access_key_list blockid_or_finality params = 
    resultOf <<< 
        rpc "query" (addBlockIdOrFinality blockid_or_finality)
            { request_type : "view_access_key_list" 
            , account_id : params.account_id
            }

type SingleAccessKeyChangesParams =
    { keys :: List 
        { account_id :: String, public_key :: String 
        } 
    }

type SingleAccessKeyChangesResult =
    { changes :: List 
        { cause :: 
            { type :: String
            , tx_hash :: String 
            }
        , type :: String
        , change :: 
            { account_id :: String
            , public_key :: String
            , access_key ::
                { permission :: Permission
                }
            }
        }
    }

single_access_key_changes :: BlockId_Or_Finality -> SingleAccessKeyChangesParams -> RpcCall SingleAccessKeyChangesResult
single_access_key_changes blockid_or_finality params =
    resultOf <<< 
        rpc "EXPERIMENTAL_changes" (addBlockIdOrFinality blockid_or_finality)
            { changes_type : "single_access_key_changes" 
            , keys : params.keys
            }

type AllAccessKeyChangesParams =
    { account_ids :: List AccountId
    }

type AllAccessKeyChangesResult =
    { }

-- Reusing the SingleAccessKeyChangesResult as it looks like the same type is returned for this call
all_access_key_changes :: BlockId_Or_Finality -> AllAccessKeyChangesParams -> RpcCall SingleAccessKeyChangesResult
all_access_key_changes blockid_or_finality params =
    resultOf <<< 
        rpc "EXPERIMENTAL_changes" (addBlockIdOrFinality blockid_or_finality)
            { changes_type : "all_access_key_changes" 
            , account_ids : params.account_ids
            }
