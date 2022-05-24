module NearApi.Rpc.Network where

import Prelude

import Data.List (List)
import Data.Maybe (Maybe)
import NearApi.Rpc.Client (RpcCall, noExtras, resultOf, rpc)

type StatusResult =
    { version :: 
        { version :: String
        , build :: String
        }
    , chain_id :: String
    , protocol_version :: Int
    , latest_protocol_version :: Int
    , rpc_addr :: String
    , validators :: List
        { account_id :: String
        , is_slashed :: Boolean
        }
    , sync_info :: 
        { latest_block_hash :: String
        , latest_block_height :: Int
        , latest_state_root :: String
        , latest_block_time :: String
        , syncing :: Boolean
        }
    , validator_account_id :: Maybe String
    }

status :: RpcCall StatusResult
status = resultOf <<< rpc "status" noExtras {}

type NetworkInfoResult =
    { active_peers :: List
        { id :: String
        , addr :: String
        , account_id :: Maybe String
        }
    , num_active_peers :: Int
    , peer_max_count :: Int
    , sent_bytes_per_sec :: Int
    , received_bytes_per_sec :: Int
    , known_producers :: List
        { account_id :: String
        , addr :: Maybe String
        , peer_id :: String
        }
    }

network_info :: RpcCall NetworkInfoResult
network_info = resultOf <<< rpc "network_info" noExtras {} 