module NearApi.Rpc.Protocol where

import Prelude

import Data.List (List)
import Data.Maybe (Maybe)
import NearApi.Rpc.Client (RpcCall, addBlockIdOrFinality, noExtras, resultOf, rpc)
import NearApi.Rpc.Types.Common (AccountId, BlockId_Or_Finality, PublicKey)

type CostSpec =
    { send_sir ∷ Number
    , send_not_sir ∷ Number
    , execution ∷ Number
    }

type GenesisConfigResult =
    { protocol_version ∷ Number
    , genesis_time ∷ String
    , chain_id ∷ String
    , genesis_height ∷ Number
    , num_block_producer_seats ∷ Number
    , num_block_producer_seats_per_shard ∷ List Number
    , avg_hidden_validator_seats_per_shard ∷ List Number
    , dynamic_resharding ∷ Boolean
    , protocol_upgrade_stake_threshold ∷ List Number
    , protocol_upgrade_num_epochs ∷ Maybe Number
    , epoch_length ∷ Number
    , gas_limit ∷ Number
    , min_gas_price ∷ String
    , max_gas_price ∷ String
    , block_producer_kickout_threshold ∷ Number
    , chunk_producer_kickout_threshold ∷ Number
    , online_min_threshold ∷ List Number
    , online_max_threshold ∷ List Number
    , gas_price_adjustment_rate ∷ List Number
    , runtime_config ∷
          Maybe
              { storage_amount_per_byte ∷ String
              , transaction_costs ∷
                    { action_receipt_creation_config ∷ CostSpec
                    , data_receipt_creation_config ∷
                          { base_cost ∷ CostSpec
                          , cost_per_byte ∷ CostSpec
                          }
                    , action_creation_config ∷
                          { create_account_cost ∷ CostSpec
                          , deploy_contract_cost ∷ CostSpec
                          , deploy_contract_cost_per_byte ∷ CostSpec
                          , function_call_cost ∷ CostSpec
                          , function_call_cost_per_byte ∷ CostSpec
                          , transfer_cost ∷ CostSpec
                          , stake_cost ∷ CostSpec
                          , add_key_cost ∷
                                { full_access_cost ∷ CostSpec
                                , function_call_cost ∷ CostSpec
                                , function_call_cost_per_byte ∷ CostSpec
                                }
                          , delete_key_cost ∷ CostSpec
                          , delete_account_cost ∷ CostSpec
                          }
                    , storage_usage_config ∷
                          { num_bytes_account ∷ Number
                          , num_extra_bytes_record ∷ Number
                          }
                    , burnt_gas_reward ∷ List Number
                    , pessimistic_gas_price_inflation_ratio ∷ List Number
                    }
              , wasm_config ∷
                    { ext_costs ∷
                          { base ∷ Number
                          -- Doesn't seem to match runtime results - so leaving to later
                          -- , contract_compile_base :: Number
                          -- , contract_compile_bytes :: Number
                          -- , read_memory_base :: Number
                          -- , read_memory_byte :: Number
                          -- , write_memory_base :: Number
                          -- , write_memory_byte :: Number
                          -- , read_register_base :: Number
                          -- , read_register_byte :: Number
                          -- , write_register_base :: Number
                          -- , write_register_byte :: Number
                          -- , utf8_decoding_base :: Number
                          -- , utf8_decoding_byte :: Number
                          -- , utf16_decoding_base :: Number
                          -- , utf16_decoding_byte :: Number
                          -- , sha256_base :: Number
                          -- , sha256_byte :: Number
                          -- , keccak256_base :: Number
                          -- , keccak256_byte :: Number
                          -- , keccak512_base :: Number
                          -- , keccak512_byte :: Number
                          -- , log_base :: Number
                          -- , log_byte :: Number
                          -- , storage_write_base :: Number
                          -- , storage_write_key_byte :: Number
                          -- , storage_write_value_byte :: Number
                          -- , storage_write_evicted_byte :: Number
                          -- , storage_read_base :: Number
                          -- , storage_read_key_byte :: Number
                          -- , storage_read_value_byte :: Number
                          -- , storage_remove_base :: Number
                          -- , storage_remove_key_byte :: Number
                          -- , storage_remove_ret_value_byte :: Number
                          -- , storage_has_key_base :: Number
                          -- , storage_has_key_byte :: Number
                          -- , storage_iter_create_prefix_base :: Number
                          -- , storage_iter_create_prefix_byte :: Number
                          -- , storage_iter_create_range_base :: Number
                          -- , storage_iter_create_from_byte :: Number
                          -- , storage_iter_create_to_byte :: Number
                          -- , storage_iter_next_base :: Number
                          -- , storage_iter_next_key_byte :: Number
                          -- , storage_iter_next_value_byte :: Number
                          -- , touching_trie_node :: Number
                          -- , promise_and_base :: Number
                          -- , promise_and_per_promise :: Number
                          -- , promise_return :: Number
                          -- , validator_stake_base :: Number
                          -- , validator_total_stake_base :: Number
                          }
                    , grow_mem_cost ∷ Number
                    , regular_op_cost ∷ Number
                    -- Doesnt match runtime - leaving for now
                    -- , limit_config :: 
                    --     { max_gas_burnt :: Number
                    --     , max_gas_burnt_view :: Number
                    --     , max_stack_height :: Number
                    --     , initial_memory_pages :: Number
                    --     , max_memory_pages :: Number
                    --     , registers_memory_limit :: Number
                    --     , max_register_size :: Number
                    --     , max_number_registers :: Number
                    --     , max_number_logs :: Number
                    --     , max_total_log_length :: Number
                    --     , max_total_prepaid_gas :: Number
                    --     , max_actions_per_receipt :: Number
                    --     , max_number_bytes_method_names :: Number
                    --     , max_length_method_name :: Number
                    --     , max_arguments_length :: Number
                    --     , max_length_returned_data :: Number
                    --     , max_contract_size :: Number
                    --     , max_length_storage_key :: Number
                    --     , max_length_storage_value :: Number
                    --     , max_promises_per_function_call_action :: Number
                    --     , max_number_input_data_dependencies :: Number
                    --     }
                    }
              , account_creation_config ∷
                    { min_allowed_top_level_account_length ∷ Number
                    , registrar_account_id ∷ String
                    }
              }
    , validators ∷
          Maybe
              ( List
                    { account_id ∷ AccountId
                    , public_key ∷ PublicKey
                    , amount ∷ String
                    }
              )
    , transaction_validity_period ∷ Number
    , protocol_reward_rate ∷ List Number
    , max_inflation_rate ∷ List Number
    , total_supply ∷ Maybe String
    , num_blocks_per_year ∷ Number
    , protocol_treasury_account ∷ String
    , fishermen_threshold ∷ String
    , minimum_stake_divisor ∷ Number
    }

genesis_config ∷ RpcCall GenesisConfigResult
genesis_config =
    resultOf <<<
        rpc "EXPERIMENTAL_genesis_config" noExtras
            {
            }

protocol_config ∷ BlockId_Or_Finality → RpcCall GenesisConfigResult
protocol_config blockid_or_finality =
    resultOf <<<
        rpc "EXPERIMENTAL_protocol_config" (addBlockIdOrFinality blockid_or_finality)
            {
            }