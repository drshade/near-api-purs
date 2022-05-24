module NearApi.Rpc.BlockChunk where

import Prelude

import Data.List (List)
import Data.Maybe (Maybe)
import NearApi.Rpc.Client (RpcCall, addBlockIdOrFinality, noExtras, resultOf, rpc)
import NearApi.Rpc.Types.Common (BlockId_Or_Finality, AccountId)

type BlockParams =
    { 
    }

type BlockResult =
    { author :: AccountId
    , header :: 
        { height :: Number
        , epoch_id :: String
        , next_epoch_id :: String
        , hash :: String
        , prev_hash :: String
        , prev_state_root :: String
        , chunk_receipts_root :: String
        , chunk_headers_root :: String
        , chunk_tx_root :: String
        , outcome_root :: String
        , chunks_included :: Number
        , challenges_root :: String
        , timestamp :: Number
        , timestamp_nanosec :: String
        , random_value :: String
        , validator_proposals :: List String
        , chunk_mask :: List Boolean
        , gas_price :: String
        , rent_paid :: String
        , validator_reward :: String
        , total_supply :: String
        , challenges_result :: List String
        , last_final_block :: String
        , last_ds_final_block :: String
        , next_bp_hash :: String
        , block_merkle_root :: String
        , approvals :: List (Maybe String)
        , signature :: String
        , latest_protocol_version :: Number
        }
    , chunks :: List 
        { chunk_hash :: String
        , prev_block_hash :: String
        , outcome_root :: String
        , prev_state_root :: String
        , encoded_merkle_root :: String
        , encoded_length :: Number
        , height_created :: Number
        , height_included :: Number
        , shard_id :: Number
        , gas_used :: Number
        , gas_limit :: Number
        , rent_paid :: String
        , validator_reward :: String
        , balance_burnt :: String
        , outgoing_receipts_root :: String
        , tx_root :: String
        , validator_proposals :: List String
        , signature :: String
        }
    }

block :: BlockId_Or_Finality -> BlockParams -> RpcCall BlockResult
block blockid_or_finality params =
    resultOf <<< 
        rpc "block" (addBlockIdOrFinality blockid_or_finality) 
            {
            }

type ChangesInBlockParams =
    {
    }

type ChangesInBlockResult =
    { changes :: List
        { type :: String
        , account_id :: AccountId
        }
    }

changes_in_block :: BlockId_Or_Finality -> ChangesInBlockParams -> RpcCall ChangesInBlockResult
changes_in_block blockid_or_finality params =
    resultOf <<< 
        rpc "EXPERIMENTAL_changes_in_block" (addBlockIdOrFinality blockid_or_finality) 
            {
            }



-- Either chunk_id, or block_id + shard_id
data ChunkParams
    = ChunkAtChunkId { chunk_id :: String }
    | ChunkAtBlockId { block_id :: String, shard_id :: Number } 

type ChunkResult =
    { author :: String
    , header :: 
        { chunk_hash :: String
        , prev_block_hash :: String
        , outcome_root :: String
        , prev_state_root :: String
        , encoded_merkle_root :: String
        , encoded_length :: Number
        , height_created :: Number
        , height_included :: Number
        , shard_id :: Number
        , gas_used :: Number
        , gas_limit :: Number
        , rent_paid :: String
        , validator_reward :: String
        , balance_burnt :: String
        , outgoing_receipts_root :: String
        , tx_root :: String
        , validator_proposals :: List String
        , signature :: String
        }
    , transactions :: List String
    , receipts :: List String
    }
    
chunk :: ChunkParams -> RpcCall ChunkResult
chunk (ChunkAtChunkId { chunk_id }) =
    resultOf <<< 
        rpc "chunk" noExtras 
            { chunk_id
            }
chunk (ChunkAtBlockId { block_id, shard_id }) =
    resultOf <<< 
        rpc "chunk" noExtras 
            { block_id
            , shard_id
            }
