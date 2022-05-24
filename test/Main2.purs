module Test.Main2 where

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
import NearApi.Rpc.Client (ClientError, NearApi, runNearApi)
import NearApi.Rpc.Network (network_info, status)
import NearApi.Rpc.NetworkConfig (testnet)
import NearApi.Rpc.Types.Common (BlockId(..), BlockId_Or_Finality(..), Finality(..))

main :: Effect Unit
main =
    let printResult :: forall a. Aff (Either ClientError a) -> Aff Unit
        printResult r = do
            er <- r
            case er of
                Left err -> log $ "Error -> " <> show err
                Right  _ -> log "No errors"
    in
    launchAff_ $ printResult $ runNearApi do
        vak <- view_access_key (BlockId $ BlockHash "4CnpiFEMiJzuE2zkbdh1hR12JjAmLekSUVEFFVPuJ5Um")
                { account_id : "tomwells.testnet"
                , public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3"
                } testnet
        log $ show vak

        vak <- view_access_key (BlockId $ BlockNumber (toNumber 90660621))
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
                    ({ keys : 
                        { account_id : "tomwells.testnet", public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3" 
                        } : Nil
                    }) testnet
        log $ show changes

        changes <- all_access_key_changes (BlockId $ BlockHash "8pX4zyWM7Sh35eCJWojLpt53oQptGff212hj8qzA9VVu") 
                    ({ account_ids : "tomwells.testnet" : Nil
                    }) testnet
        log $ show changes

        status <- status testnet
        log $ show status

        info <- network_info testnet
        log $ show info

        log "done"