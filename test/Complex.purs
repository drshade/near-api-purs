module Test.Complex where

import Prelude

import Control.Monad.Except (ExceptT(..), runExceptT)
import Data.Either (Either(..))
import Data.Foldable (sequence_)
import Data.Int (toNumber)
import Data.List ((:), List(Nil))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Aff.Class (liftAff)
import Effect.Class.Console (log)
import NearApi.Rpc.AccessKeys (ViewAccessKeyListResult, ViewAccessKeyResult, all_access_key_changes, single_access_key_changes, view_access_key, view_access_key_list)
import NearApi.Rpc.AccountsContracts (account_changes, call_function, contract_code_changes, data_changes, view_account, view_code, view_state)
import NearApi.Rpc.BlockChunk (ChunkParams(..), block, changes_in_block, chunk)
import NearApi.Rpc.Client (ClientError, NearApi, runNearApi)
import NearApi.Rpc.Gas (GasPriceParams(..), gas_price)
import NearApi.Rpc.Network (ValidatorsParams(..), network_info, status, validators)
import NearApi.Rpc.NetworkConfig (testnet)
import NearApi.Rpc.Protocol (genesis_config, protocol_config)
import NearApi.Rpc.Transactions (receipt_id, tx, tx_status_with_receipts)
import NearApi.Rpc.Types.Common (BlockId(..), BlockId_Or_Finality(..), Finality(..))
import Prim.RowList (Nil)

main :: Effect Unit
main =
    let blockHash = "BfG53pSokBty5C5WzyaVD7RDQLxcJ6WwrT9e1waGpomY"
        blockNumber = 98243975
        printResult :: forall a. Aff (Either ClientError a) -> Aff Unit
        printResult r = do
            er <- r
            case er of
                Left err -> log $ "Error -> " <> show err
                Right  _ -> log "No errors"
    in
    launchAff_ $ printResult $ runNearApi do
        vak <- view_access_key (BlockId $ BlockHash blockHash)
                { account_id : "tomwells.testnet"
                , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
                } testnet
        log $ show vak

        vak <- view_access_key (BlockId $ BlockNumber (toNumber blockNumber))
                { account_id : "tomwells.testnet"
                , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
                } testnet
        log $ show vak

        vak <- view_access_key (Finality Optimistic)
                { account_id : "tomwells.testnet"
                , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
                } testnet
        log $ show vak

        vak <- view_access_key (Finality Final) 
                { account_id : "tomwells.testnet"
                , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
                } testnet
        log $ show vak

        vakl <- view_access_key_list (Finality Final) { account_id : "tomwells.testnet" } testnet
        log $ show vakl

        changes <- single_access_key_changes (Finality Final) 
                    { keys : 
                        { account_id : "tomwells.testnet", public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3" 
                        } : Nil
                    } testnet
        log $ show changes

        changes <- all_access_key_changes (BlockId $ BlockHash blockHash) 
                    { account_ids : "tomwells.testnet" : Nil
                    } testnet
        log $ show changes

        status <- status testnet
        log $ show status

        info <- network_info testnet
        log $ show info

        account <- view_account (Finality Final) 
                    { account_id: "tomwells.testnet" 
                    } testnet
        log $ show account

        changes <- account_changes (Finality Final)
                    { account_ids: "tomwells.testnet" : Nil
                    } testnet
        log $ show changes

        code <- view_code (Finality Final)
                    { account_id: "2.burner.unlockable.testnet"
                    } testnet
        log $ show code

        state <- view_state (Finality Final)
                    { account_id: "burner1.drshade.testnet"
                    , prefix_base64: ""
                    } testnet
        log $ show state

        changes <- data_changes (Finality Final)
                        { account_ids : "burner1.drshade.testnet" : Nil
                        , key_prefix_base64 : ""
                        } testnet
        log $ show changes

        changes <- contract_code_changes (Finality Final)
                        { account_ids : "burner1.drshade.testnet" : Nil
                        } testnet
        log $ show changes

        result <- call_function (Finality Final)
                        { account_id : "burner1.drshade.testnet"
                        , method_name : "get_messages"
                        , args_base64 : ""
                        } testnet
        log $ show result

        block <- block (Finality Final) testnet
        log $ show block

        changes <- changes_in_block (Finality Final) testnet
        log $ show changes

        chunk <- chunk (ChunkAtChunkId 
                        { chunk_id: "CeWk2xYiet4VvZXvXJ9mCiWd1VH23wG8Ztc3cpJRe4Mg" 
                        }) testnet
        log $ show chunk

        price <- gas_price (GasPriceLatest)
                        testnet
        log $ show price

        config <- genesis_config testnet
        log $ show config

        config <- protocol_config (Finality Final) testnet
        log $ show config

        validators <- validators (ValidatorsLatest) testnet
        log $ show validators

        txstatus <- tx { sender: "zml.testnet"
                       , transaction_hash: "EJM3ubBbXXRSeQfbYiX7PKYdLrBDe2fU3i5wL4aTFfEe"
                       } testnet
        log $ show txstatus

        txstatus <- tx_status_with_receipts
                       { sender: "zml.testnet"
                       , transaction_hash: "EJM3ubBbXXRSeQfbYiX7PKYdLrBDe2fU3i5wL4aTFfEe"
                       } testnet
        log $ show txstatus

        receipt <- receipt_id
                      { receipt_id: "3qGNnAMkzqD9GKo9SkAvrqiUL8GUGxN8padw8WPRhDDx" 
                      } testnet
        log $ show receipt

        log "done"