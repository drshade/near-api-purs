module NearApi.Rpc.Network where

import Prelude

import Data.Argonaut.Core (fromNumber, fromString, jsonNull, jsonSingletonArray)
import Data.List (List)
import Data.Maybe (Maybe)
import NearApi.Rpc.Client (RpcCall, addRawParams, noExtras, resultOf, rpc)
import NearApi.Rpc.Types.Common (AccountId, PublicKey)

type StatusResult =
    { version ∷
          { version ∷ String
          , build ∷ String
          }
    , chain_id ∷ String
    , protocol_version ∷ Int
    , latest_protocol_version ∷ Int
    , rpc_addr ∷ String
    , validators ∷
          List
              { account_id ∷ String
              , is_slashed ∷ Boolean
              }
    , sync_info ∷
          { latest_block_hash ∷ String
          , latest_block_height ∷ Int
          , latest_state_root ∷ String
          , latest_block_time ∷ String
          , syncing ∷ Boolean
          }
    , validator_account_id ∷ Maybe String
    }

status ∷ RpcCall StatusResult
status = resultOf <<< rpc "status" noExtras {}

type NetworkInfoResult =
    { active_peers ∷
          List
              { id ∷ String
              , addr ∷ String
              , account_id ∷ Maybe String
              }
    , num_active_peers ∷ Int
    , peer_max_count ∷ Int
    , sent_bytes_per_sec ∷ Int
    , received_bytes_per_sec ∷ Int
    , known_producers ∷
          List
              { account_id ∷ String
              , addr ∷ Maybe String
              , peer_id ∷ String
              }
    }

network_info ∷ RpcCall NetworkInfoResult
network_info = resultOf <<< rpc "network_info" noExtras {}

data ValidatorsParams
    = ValidatorsLatest
    | ValidatorsAtBlockHeight Number
    | ValidatorsAtBlockHash String

type ValidatorsResult =
    { current_validators ∷
          List
              { account_id ∷ AccountId
              , public_key ∷ PublicKey
              , is_slashed ∷ Boolean
              , stake ∷ String
              , shards ∷ List Number
              , num_produced_blocks ∷ Number
              , num_expected_blocks ∷ Number
              }
    , next_validators ∷
          List
              { account_id ∷ AccountId
              , public_key ∷ PublicKey
              , stake ∷ String
              , shards ∷ List Number
              }
    , current_fishermen ∷
          List
              { account_id ∷ AccountId
              , public_key ∷ PublicKey
              , stake ∷ String
              }
    , next_fishermen ∷
          List
              { account_id ∷ AccountId
              , public_key ∷ PublicKey
              , stake ∷ String
              }
    , current_proposals ∷
          List
              { account_id ∷ AccountId
              , public_key ∷ PublicKey
              , stake ∷ String
              }
    , prev_epoch_kickout ∷
          List
              { account_id ∷ AccountId
              , reason ∷
                    { "NotEnoughBlocks" ∷
                          Maybe
                              { expected ∷ Number
                              , produced ∷ Number
                              }
                    -- Could be other reasons? Add them!
                    }
              }
    , epoch_start_height ∷ Number
    , epoch_height ∷ Number
    }

validators ∷ ValidatorsParams → RpcCall ValidatorsResult
validators ValidatorsLatest =
    resultOf <<< rpc "validators" (addRawParams $ jsonSingletonArray jsonNull) {}
validators (ValidatorsAtBlockHeight block_height) =
    resultOf <<< rpc "validators" (addRawParams $ jsonSingletonArray $ fromNumber block_height) {}
validators (ValidatorsAtBlockHash block_hash) =
    resultOf <<< rpc "validators" (addRawParams $ jsonSingletonArray $ fromString block_hash) {}
